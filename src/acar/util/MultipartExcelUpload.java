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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class MultipartExcelUpload {
	static private MultipartExcelUpload instance = null;

	public MultipartExcelUpload() {}

	static synchronized public MultipartExcelUpload getInstance() {
		if (instance == null) {
			instance = new MultipartExcelUpload();
		}

		return instance;
	}

	@SuppressWarnings("rawtypes")
	public Hashtable MultipartRequestExcelSave(HttpServletRequest request, HttpServletResponse response, int maxPostSize, String savePath) throws Exception,
			IOException {
		if (request == null) {
			throw new IllegalArgumentException("request cannot be null");
		}

		if (savePath == null) {
			throw new IllegalArgumentException("saveDirectory cannot be null");
		}

		if (maxPostSize <= 0) {
			throw new IllegalArgumentException("maxPostSize must be positive");
		}

		File dir = new File(savePath);

		if (!dir.canWrite()) {
			throw new IllegalArgumentException("Not writable: Folder");
		}
		System.out.println("go save!");
		return save(request, response, maxPostSize, savePath);
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Hashtable save(HttpServletRequest request, HttpServletResponse response, int maxSize, String savePath) throws Exception {
		System.out.println("start save!");
		response.setContentType("text/html");

		PrintWriter out = response.getWriter();

		boolean isMultipart = ServletFileUpload.isMultipartContent(request);
		System.out.println("isMultipart >>" + isMultipart);
		if (!isMultipart) {
			System.out.println("not supported encoding type!!");
			out.println("인코딩 타입이 multipart/form-data 가 아님.");

			return null;
		}

		File temporaryDir = new File(savePath);

		DiskFileItemFactory factory = new DiskFileItemFactory();

		factory.setSizeThreshold(1 * 1024 * 1024);

		factory.setRepository(temporaryDir);

		ServletFileUpload upload = new ServletFileUpload(factory);

		upload.setSizeMax(-1);

		List<FileItem> items = upload.parseRequest(request);

		Iterator<FileItem> iter = items.iterator();

		Hashtable parameters = new Hashtable();

		String saveName = "";
		// 업로드 파일이 1개인 경우를 가정하고 있습니다.
		while (iter.hasNext()) {
			FileItem fileItem = (FileItem) iter.next();

			if (fileItem.isFormField()) {
				parameters.put(fileItem.getFieldName(), fileItem.getString());
				System.out.println("111-1 >> "+fileItem.getFieldName());
				System.out.println("111-2 >> "+fileItem.getString());
				continue;
			}

			if (fileItem.getSize() <= 0) {
				System.out.println("222");
				continue;
			}

			if (maxSize > 0 && maxSize < fileItem.getSize()) {
				out.println("용량초과 : 파일명(" + fileItem.getName() + ") / 허용용량(" + maxSize + ") / 파일용량(" + fileItem.getSize() + ")");
				System.out.println("333");
				fileItem.delete();

				continue;
			}

			String fileName = fileItem.getName();
			System.out.println("1212fileName >> " + fileName);
			

			String suffix = getExcelFileExtension(fileName);

			if (suffix.indexOf("xlsx") == -1 && suffix.indexOf("xls") == -1) {
				out.println(suffix + " : 확장자가 엑셀파일이 아닙니다.");

				continue;
			}

			saveName = Long.toString(System.currentTimeMillis()) + "_" + getRandomText() + "." + suffix;
			System.out.println("saveName >>> " + saveName);
			try {
				File uploadedFile = new File(savePath, saveName);

				fileItem.write(uploadedFile);

				fileItem.delete();
			} catch (IOException ex) {
				out.println("파일 쓰기 에러");
			}
		}

		parameters.put("fileName", saveName);

		return parameters;
	}

	@SuppressWarnings("rawtypes")
	public Vector getExcelData(HttpServletResponse response, String uploadPath, String fileName) throws Exception {
		response.setContentType("text/html");

		PrintWriter out = response.getWriter();

		String suffix = getExcelFileExtension(fileName);

		if (suffix == null) {
			out.println(suffix + " : 확장자가 엑셀파일이 아닙니다.");

			return null;
		}

		Vector vt = new Vector();

		if (suffix.equals("xls")) {
			vt = getXLSData(uploadPath, fileName);
		} else if (suffix.equals("xlsx")) {
			vt = getXLSXData(uploadPath, fileName);
		} else {
			return null;
		}

		return vt;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Vector getXLSData(String uploadPath, String fileName) throws Exception {
		Vector vt = new Vector();

		FileInputStream fis = null;

		fis = new FileInputStream(new File(uploadPath + "" + fileName));

		HSSFWorkbook workbook = new HSSFWorkbook(fis);

		HSSFSheet sheet = null;

		sheet = workbook.getSheetAt(0);

		Iterator<Row> rowIterator = sheet.iterator();

		while(rowIterator.hasNext()) {
			Row row = rowIterator.next();
         
			Iterator<Cell> cellIterator = row.cellIterator();

			ArrayList cellArray = new ArrayList();

			while(cellIterator.hasNext()) {
				Cell cell = cellIterator.next();

				String value = null;

				if (cell != null) {
					switch (cell.getCellType()) {
					case HSSFCell.CELL_TYPE_FORMULA:
					case HSSFCell.CELL_TYPE_ERROR:
						break;
					case HSSFCell.CELL_TYPE_NUMERIC:
						cell.setCellType(HSSFCell.CELL_TYPE_STRING);

						value = "" + cell.getStringCellValue();

						break;
					case HSSFCell.CELL_TYPE_STRING:
						value = "" + cell.getStringCellValue();

						break;
					case HSSFCell.CELL_TYPE_BLANK:
						value = "";

						break;
					default:
						value = "";
					}

					cellArray.add(value);
				}
			}

			vt.add(cellArray);

			if (workbook != null) {
				try {
					workbook.close();
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

		return vt;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Vector getXLSXData(String uploadPath, String fileName) throws Exception {
		Vector vt = new Vector();

		FileInputStream fis = null;

		fis = new FileInputStream(new File(uploadPath + "" + fileName));

		XSSFWorkbook workbook = new XSSFWorkbook(fis);

		XSSFSheet sheet = null;

		sheet = workbook.getSheetAt(0);

		Iterator<Row> rowIterator = sheet.iterator();

		while(rowIterator.hasNext()) {
			Row row = rowIterator.next();
         
			Iterator<Cell> cellIterator = row.cellIterator();

			ArrayList cellArray = new ArrayList();

			while(cellIterator.hasNext()) {
				Cell cell = cellIterator.next();

				String value = null;

				if (cell != null) {
					switch (cell.getCellType()) {
					case XSSFCell.CELL_TYPE_FORMULA:
					case XSSFCell.CELL_TYPE_ERROR:
						break;
					case XSSFCell.CELL_TYPE_NUMERIC:
						cell.setCellType(HSSFCell.CELL_TYPE_STRING);

						value = "" + cell.getStringCellValue();

						break;
					case XSSFCell.CELL_TYPE_STRING:
						value = "" + cell.getStringCellValue();

						break;
					case XSSFCell.CELL_TYPE_BLANK:
						value = "";

						break;
					default:
						value = "";
					}

					cellArray.add(value);
				}
			}

			vt.add(cellArray);

			if (workbook != null) {
				try {
					workbook.close();
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

		return vt;
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
