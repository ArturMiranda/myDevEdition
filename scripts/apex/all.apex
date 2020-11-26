// Test Exceptions
CustomThrowExceptions.mainProcessing();
CustomThrowExceptions.nullException();
CustomThrowExceptions.queryException();
CustomThrowExceptions.queryUpdate();


// setScale
Decimal toround = 3.14159265;
Decimal rounded = toRound.setScale(2, RoundingMode.HALF_UP);
system.debug(rounded);