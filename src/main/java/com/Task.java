package com;

import java.io.FileWriter;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class Task {
	
static String BASEPATH = "/assets/images";
	
	public static void main(String[] args) throws SQLException {
		System.out.println("starts .......");
		List<String> ids = getIdsList();
		System.out.println("print ids - "+ids);
		List<String> paths = createPaths(ids);
		paths.forEach(path-> {
			System.out.println(path);
		});
		System.out.println("writing task is now started..");
		writePath(paths);
		System.out.println("writing task is now finished..");
       
    }
	
	
	private static void writePath(List<String> paths){
		
		try {
			FileWriter fw;
			fw = new FileWriter("web2prod_photo-assets_25-10-2018.txt");
		

		paths.forEach(path -> {
				try {
					fw.write(path);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			    try {
					fw.write("\n");
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		});
		fw.close();
		
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
	
	
	private static List<String> getIdsList() {
		System.out.println("running createPaths() .......");
		List<String> idlist = new ArrayList<>();
		
		String photoAssetSql = "Any Query  which provides result ........";
		
		try {
			Connection con = ConnectionPooling.INSTACE.getConnection();
			Statement sqlStatement = con.createStatement();
		//	String readRecordSQL = "select * from item where rownum < 10 ";
			ResultSet myResultSet;
			System.out.println("query -> "+photoAssetSql);
			System.out.println("star executing process ");
			long startTime = System.currentTimeMillis();
			myResultSet = sqlStatement.executeQuery(photoAssetSql);
			long endTime = System.currentTimeMillis();
			double time = (endTime - startTime) / 1000.0;
			System.out.println("finished  executeQuery() ....... Time taken -> "+time);
			
			while (myResultSet.next()) {
				idlist.add(myResultSet.getString("item_id"));
			}
			System.out.println("iteration finished...");
			myResultSet.close();
			con.close();
			System.out.println("closed connection");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return idlist;
	}
	
	private static String getNfsStylePath(String assetId) {
		if ("".equals(assetId))return assetId;
		String idDir = "";
		int idLength = assetId.length();
		if (idLength >= 3)
			idDir = assetId.substring(idLength - 3).replaceAll("", "/");
		else
			idDir = "/";
		idDir = idDir + assetId;

		return idDir;
	}

	
	private static List<String> createPaths(List<String> ids){
		List<String> pathlist = new ArrayList<>();
		
		ids.forEach(id-> {
			pathlist.add(BASEPATH+getNfsStylePath(id));
		});
		
		return pathlist;
	}
}
