import org.iban4j.Iban;
import org.iban4j.IbanFormatException;
import org.iban4j.IbanUtil;
import org.iban4j.InvalidCheckDigitException;
import org.iban4j.UnsupportedCountryException;
import java.nio.file.Paths;
import java.nio.file.Files;
import java.nio.file.Path;

public class fuzz {
    public static void main(String[] args) throws Exception
    {
        Path path = Paths.get(args[0]);
        byte[] data = Files.readAllBytes(path);
        if(data.length == 0) {
            return;
        }

        System.out.println(new String(data));
        
        try {
            Iban.valueOf(new String(data));
            IbanUtil.validate(new String(data));
        } catch (IbanFormatException |
        InvalidCheckDigitException |
        UnsupportedCountryException e) {
        // invalid
        }
    }
}
