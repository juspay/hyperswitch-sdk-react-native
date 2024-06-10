import React from 'react';
import {
  type StyleProp,
  StyleSheet,
  Text,
  type TextStyle,
  TouchableOpacity,
  type ViewStyle,
} from 'react-native';

type Props = {
  disabled?: boolean;
  callback: () => void;
  style?: StyleProp<ViewStyle>;
  textStyle?: StyleProp<TextStyle>;
  buttonText: string;
  loading?: boolean;
};

const Button = ({
  callback,
  loading,
  style,
  disabled,
  textStyle,
  buttonText,
}: Props) => {
  // Memoize the dynamic styles for optimization
  const buttonStyles = React.useMemo(
    () => [styles.button, { opacity: disabled || loading ? 0.6 : 1 }, style],
    [disabled, loading, style]
  );

  return (
    <TouchableOpacity
      disabled={disabled}
      onPress={callback}
      style={buttonStyles}
    >
      <Text style={[styles.buttonText, textStyle]}>
        {loading ? 'Loading...' : buttonText}
      </Text>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  button: {
    width: '100%',
    height: 60,
    backgroundColor: '#3680ef',
    padding: 10,
    alignItems: 'center',
    justifyContent: 'center',
    color: 'white',
    borderRadius: 10,
    borderWidth: 1,
    borderColor: 'white',
  },
  buttonText: {
    color: '#fff',
    fontSize: 19,
  },
});
export default Button;
