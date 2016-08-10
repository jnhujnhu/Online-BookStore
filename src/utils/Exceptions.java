package utils;

import java.sql.ResultSet;
import java.sql.Statement;

/**
 * Created by Kevin on 8/10/16.
 */
public class Exceptions {

    public static ResultSet handleQueryExp(Statement stmt, String query, String Err) {
        ResultSet result = null;
        try {
            result = stmt.executeQuery(query);
        } catch(Exception e) {
            System.err.println(Err);
            System.err.println(e.getMessage());
        }
        return result;
    }

    public static void handleUpdateExp(Statement stmt, String query, String Err) {
        try {
            stmt.executeUpdate(query);
        } catch (Exception e) {
            System.err.println(Err);
            System.err.println(e.getMessage());
        }
    }
}
