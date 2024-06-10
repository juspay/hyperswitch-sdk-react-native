import React from 'react';
import { useNavigationState } from '@react-navigation/native';
import { useCallback, useMemo, type PropsWithChildren } from 'react';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import {
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  useColorScheme,
  View,
} from 'react-native';
import { Colors } from 'react-native/Libraries/NewAppScreen';

type SectionProps = PropsWithChildren<{
  title: string;
  options?: string[];
  navigation: any;
}>;

const Section = ({
  children,
  navigation,
  options,
}: SectionProps): React.JSX.Element => {
  const activeIndex = useNavigationState((state) => state.index);
  const insets = useSafeAreaInsets();
  const isDarkMode = useColorScheme() === 'dark';

  // Memoize backgroundStyle
  const backgroundStyle = useMemo(
    () => ({
      backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
    }),
    [isDarkMode]
  );

  // Handle navigation in a memoized function
  const handlePress = useCallback(
    (option: string) => {
      navigation.navigate(option);
    },
    [navigation]
  );

  return (
    <View
      style={[
        {
          paddingTop: insets.top,
          paddingBottom: insets.bottom,
          flex: 1,
        },
        backgroundStyle,
      ]}
    >
      <View
        style={[
          styles.tabMainContainer,
          {
            borderBottomColor: isDarkMode ? 'white' : 'black',
          },
        ]}
      >
        <ScrollView horizontal contentContainerStyle={styles.tabContainer}>
          {options?.map((option: string, index) => {
            const isActive = index === activeIndex;
            return (
              <TouchableOpacity
                key={index}
                style={styles.tabItem}
                onPress={() => handlePress(option)}
              >
                <Text
                  style={[
                    styles.tabText,
                    {
                      color: isDarkMode ? 'white' : 'black',
                      fontWeight: isActive ? '700' : '300',
                    },
                  ]}
                >
                  {option}
                </Text>
                {isActive && <View style={styles.activeTabUnderline} />}
              </TouchableOpacity>
            );
          })}
        </ScrollView>
      </View>
      <View style={styles.sectionChildren}>{children}</View>
    </View>
  );
};

const styles = StyleSheet.create({
  tabContainer: {
    paddingVertical: 0.2,
    justifyContent: 'space-evenly',
    width: '100%',
  },
  tabMainContainer: {
    borderBottomColor: 'black',
    borderBottomWidth: 1,
  },
  tabItem: {
    flex: 1,
    alignItems: 'center',
    width: '100%',
    gap: 20,
  },
  tabText: {
    fontSize: 18,
  },
  activeTabUnderline: {
    borderColor: '#3680ef',
    borderBottomWidth: 3,
    width: '100%',
  },
  sectionChildren: {
    paddingVertical: 24,
    alignItems: 'center',
  },
});

export default Section;
