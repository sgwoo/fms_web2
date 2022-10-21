package acar.util;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class XlsxRead {

	public HashMap<Integer, Object> readXlsxData(HttpServletRequest request, String filePath){
		
		HashMap<Integer, Object> listMap = new HashMap<Integer, Object>();
		
		try{
			String realFolder = request.getRealPath("/");
			FileInputStream fis=new FileInputStream(realFolder + filePath);
			XSSFWorkbook workbook=new XSSFWorkbook(fis);
			
			int rowindex=0;
			int columnindex=0;
			XSSFSheet sheet=workbook.getSheetAt(0);
			//ÇàÀÇ ¼ö
			int rows=sheet.getPhysicalNumberOfRows();
			List<String> xlsxdata = new ArrayList<String>();
			
			for(rowindex=0;rowindex<rows;rowindex++){
				xlsxdata = new ArrayList<String>();
			    XSSFRow row=sheet.getRow(rowindex);
			    if(row !=null){
			        int cells=row.getPhysicalNumberOfCells();
			        for(columnindex=0;columnindex<=cells  ;columnindex++){
			            XSSFCell cell=row.getCell(columnindex);
			            String value="";
			            if(cell==null){
			            	value = " &nbsp; ";
			                //continue;
			            }else{
			                switch (cell.getCellType()){
				                case XSSFCell.CELL_TYPE_FORMULA:
				                    value=cell.getCellFormula();
				                    break;
				                case XSSFCell.CELL_TYPE_NUMERIC:
				                    value = cell.getNumericCellValue()+"";
				                    break;
				                case XSSFCell.CELL_TYPE_STRING:
				                    value=cell.getStringCellValue()+"";
				                    break;
				                case XSSFCell.CELL_TYPE_BLANK:
				                    value=cell.getBooleanCellValue()+"";
				                    break;
				                case XSSFCell.CELL_TYPE_ERROR:
				                    value=cell.getErrorCellValue()+"";
				                    break;
			                }
			            }
			            xlsxdata.add(value);
			        }
			    }
			    
			    listMap.put(rowindex+1, xlsxdata);
			    
			}
			
			fis.close();
		
		}catch( Exception e ){
			System.out.println("Excel Access Exception !! ");
		}
		return listMap;
	}
}