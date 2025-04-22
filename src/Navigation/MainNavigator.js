import React from "react";
import { NavigationContainer } from "@react-navigation/native";
import { createstackNavigator } from "@react-navigation/stack";
import RequestForms from "../Screens/RequestForms";

const Stack = createstackNavigator();

const MainNavigator = () => {
  return (
    <NavigationContainer>
      <Stack.Navigator>
        <Stack.Screen name="Request" component={RequestForms} />
      </Stack.Navigator>
    </NavigationContainer>
  );
};
export default MainNavigator;
