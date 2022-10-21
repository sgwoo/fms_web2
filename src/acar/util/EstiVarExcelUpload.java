package acar.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;
import java.text.*;
import jxl.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class EstiVarExcelUpload {
	
	//엑셀 확장자 xls
	public static Vector getXLSData(String uploadPath, String fileName, int startIndex) throws Exception {
		
		Vector vt = new Vector();
		
		FileInputStream fis = null;

		fis = new FileInputStream(new File(uploadPath + "" + fileName));

		HSSFWorkbook workBook = new HSSFWorkbook(fis);
		HSSFSheet sheet = null;
		HSSFRow row = null;
		HSSFCell cell = null;
		
		sheet = workBook.getSheetAt(0);

		Iterator<Row> rowIterator = sheet.iterator();

		while (rowIterator.hasNext()) {
			//Row row = rowIterator.next();
			row = (HSSFRow) rowIterator.next();
			
			int row_index = row.getRowNum();
			
			//startIndex 행부터 data 로드
            if (row.getRowNum() < startIndex) {
                
            	continue;
                
            } else {
            	
            	Iterator<Cell> cellIterator = row.cellIterator();
            	
            	ArrayList cellArray = new ArrayList();
            	Hashtable ht = new Hashtable();
            	
            	while (cellIterator.hasNext()) {
            		//Cell cell = cellIterator.next();
            		cell = (HSSFCell) cellIterator.next();
            		
            		String value = null;
            		
            		int cell_index = cell.getColumnIndex(); //index는 열 순서를 의미, 0부터 시작
            		
            		if (cell != null) {
            			//value = row.getCell(index).toString();
            			//value = row.getCell(cell_index).getStringCellValue();
            			DataFormatter formatter = new DataFormatter();
            			value = formatter.formatCellValue(sheet.getRow(row_index).getCell(cell_index));

            			if (value.contains("#REF!")) {
            				value = "";
            			}
            			
            			//cellArray.add(value);
            			ht.put(Integer.toString(cell_index), value);
            			
            		}
            	}
            	
            	//vt.add(cellArray);
            	vt.add(ht);
            	
            	if (workBook != null) {
            		try {
            			workBook.close();
            		} catch (IOException e) {
            			e.printStackTrace();
            		}
            	}
            	
            	if (fis != null) {
            		try {
            			fis.close();
            		} catch (IOException e) {
            			e.printStackTrace();
            		}
            	}
            }			
		}

		return vt;
	}
	
	//엑셀 확장자 xlsx
	public static Vector getXLSXData(String uploadPath, String fileName, int startIndex) throws Exception {
		
		Vector vt = new Vector();
		
		FileInputStream fis = null;
		
		fis = new FileInputStream(new File(uploadPath + "" + fileName));
		
		XSSFWorkbook workBook = new XSSFWorkbook(fis);		   
		XSSFSheet sheet = null;
		XSSFRow row = null;
		XSSFCell cell = null;
		
		sheet = workBook.getSheetAt(0);
		
		Iterator<Row> rowIterator = sheet.iterator();
		
		while (rowIterator.hasNext()) {
			//Row row = rowIterator.next();
			row = (XSSFRow) rowIterator.next();
			
			int row_index = row.getRowNum();
			
			//startIndex 행부터 data 로드
			if (row.getRowNum() < startIndex) {
				
				continue;
				
			} else {
				
				Iterator<Cell> cellIterator = row.cellIterator();
				
				ArrayList cellArray = new ArrayList();
				Hashtable ht = new Hashtable();
				
				while (cellIterator.hasNext()) {
					//Cell cell = cellIterator.next();
					cell = (XSSFCell) cellIterator.next();
					
					String value = null;
					
					int cell_index = cell.getColumnIndex(); //index는 열 순서를 의미, 0부터 시작
					
					if (cell != null) {

						//value = row.getCell(index).toString();						
						//value = row.getCell(cell_index).getStringCellValue();
						
						DataFormatter formatter = new DataFormatter();
						value = formatter.formatCellValue(sheet.getRow(row_index).getCell(cell_index));
						
						if (value.contains("#REF!")) {
            				value = "";
            			}
						
						//cellArray.add(value);
						ht.put(Integer.toString(cell_index), value);
					}
				}
				
				//vt.add(cellArray);
				vt.add(ht);
				
				if (workBook != null) {
					try {
						workBook.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
				
				if (fis != null) {
					try {
						fis.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
			
		}
		
		return vt;
	}

	public static int getXLSDataColSize(String uploadPath, String fileName, int startIndex) throws Exception {
		
		FileInputStream fis = null;

		fis = new FileInputStream(new File(uploadPath + "" + fileName));

		HSSFWorkbook workBook = new HSSFWorkbook(fis);
		HSSFSheet sheet = null;
		HSSFRow row = null;
		HSSFCell cell = null;
		
		sheet = workBook.getSheetAt(0);		
		row = sheet.getRow(startIndex);
		
		int colSize = row.getLastCellNum();

		return colSize;
	}
	
	public static int getXLSXDataColSize(String uploadPath, String fileName, int startIndex) throws Exception {
		
		FileInputStream fis = null;

		fis = new FileInputStream(new File(uploadPath + "" + fileName));

		XSSFWorkbook workBook = new XSSFWorkbook(fis);		   
		XSSFSheet sheet = null;
		XSSFRow row = null;
		XSSFCell cell = null;
		
		sheet = workBook.getSheetAt(0);		
		row = sheet.getRow(startIndex);
		
		int colSize = row.getLastCellNum();

		return colSize;
	}
	
	public String getExcelFileExtension(String fileName) {
		int lastDotIndex = fileName.lastIndexOf(".");
		
		return fileName.substring(lastDotIndex + 1, fileName.length());
	}

	public String getRandomText() {
		String[] args = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};

		String returnString = "";

		for (int i = 0; i < 10; i++) {
			int randomInt = (int) (Math.random() * 36);

			returnString += args[randomInt];
		}

		return returnString;
	}
}
