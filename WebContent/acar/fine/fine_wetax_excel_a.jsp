<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.customer.*, acar.forfeit_mng.*, acar.user_mng.*"%>
<jsp:useBean id="cu_db" class="acar.customer.Customer_Database" scope="page"/>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<%
	
	
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String result[]  = new String[value_line];
	String value11[]  = request.getParameterValues("value11"); // 위반내용
	String value8[]  = request.getParameterValues("value8"); // 고지번호
	String value5[]  = request.getParameterValues("value5"); // 차량번호
	String value4[]  = request.getParameterValues("value4"); // 위반장소
	String value3[]  = request.getParameterValues("value3"); // 위반일시
	String value7[]  = request.getParameterValues("value7"); // 부과액
	String value6[]  = request.getParameterValues("value6");  // 납부기간
	String value1[]	 = request.getParameterValues("value1");  // 부과년월

	int flag = 0;
	int error = 0;
	int seq = 0;
	int seq2 = 0;
	int count = 0;
	String reg_code  = Long.toString(System.currentTimeMillis());
	String car_no 		= "";
	String js_dt 		= "";
	String c_id = "";
	String m_id = "";
	String l_cd = "";
	String mng_id = "";
	String seq_no = "";
	String paid_no ="";
	String paid_no2 ="";
	String vio_cont = "";
	String s_cd = "";
	String fine_off ="";
	String gov_nm ="";
	String rent_st = "";
	String vio_dt = "";
	String vio_pla = "";
	
	LoginBean login = LoginBean.getInstance();
	//과태료정보
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	for(int i=start_row ; i < value_line ; i++){
		fine_off		= value8[i] == null?"":value8[i].substring(0,7);
		Hashtable ht3 = cu_db.fine_off_search_wetax(fine_off);
		gov_nm = String.valueOf(ht3.get("GOV_ID"));
		
		if(value5[i] == null || value5[i].equals("") || value5[i].equals(" ") ||
		   value4[i] == null || value4[i].equals("") || value4[i].equals(" ") ||
		   value3[i] == null || value3[i].equals("") || value3[i].equals(" ")) {
			
			HashMap<String, Object> map= new HashMap<>();
	   		map.put("car_no",value5[i]);
	   		map.put("gov_nm",gov_nm);
	   		map.put("paid_no",value8[i]);
	   		map.put("vio_pla",value4[i]);
	   		map.put("vio_dt",value3[i]);
	   		map.put("vio_cont",value11[i]);
	   		map.put("paid_amt",AddUtil.parseInt(value7[i]));
	   		map.put("paid_end_dt",value6[i]);
	   		map.put("impose_dt",value1[i]);
	   		
	   		// 임시 테이블 데이터 중복 검사
			Vector finesTemp = a_fdb.getFineTempList((String)map.get("paid_no"));
			int finesTempSize = finesTemp.size();
			if(finesTempSize <= 0) {
				a_fdb.insertFineWetaxTemp(map);
			}
			
			result[i] = "위반 장소 /  위반 일시 / 차량 번호 중 없는 데이터가 있어 임시 테이블에 저장했습니다.";
			
			continue;
		}
		
		car_no 			= value5[i] == null?"":value5[i];
		vio_pla			= value4[i] == null?"":value4[i];
		vio_dt			= value3[i]  == null?"":value11[i];
		try{
			js_dt			= value3[i] == null?"":value3[i].substring(0,8);
		} catch (IndexOutOfBoundsException e) {
			result[i] = "위반일시가 잘못되었습니다. 확인 후 다시 등록해주세요.";
			continue;
		}
		
		//일괄등록에서는 고객을 자동으로 fetch해오는 과정에서 잘못된 고객정보를 가져올수 있음. -> 이런건들만 체크해 고객확인 후 직접 수동등록하도록 수정.(20190724)
		if(!car_no.equals("") && !js_dt.equals("")){
			Vector vt_s = a_fdb.getFineSearchContList(car_no, js_dt);
			if(vt_s.size()>1){
				result[i] = "고객이 중복 검색되어 일괄 등록에서 제외되었습니다. 직접등록해주세요.";
				continue;
			}
		}
		
	//	Hashtable ht = cu_db.speed_Serach(car_no, js_dt); 
	// VVV 담당자가 날짜 미입력 등으로 여러건이 조회될수 있는데 1건만 fetch되고 그건이 잘못된 정보일수 있어서 수정(20190829)
		Vector vt_s2 = cu_db.getFine_maker(car_no, js_dt); 
		if(vt_s2.size() == 1){
			for(int j=0; j<vt_s2.size();j++){
				Hashtable ht_s2 = (Hashtable)vt_s2.elementAt(j);
				
				c_id 		= String.valueOf(ht_s2.get("CAR_MNG_ID")); 
				m_id 	= String.valueOf(ht_s2.get("RENT_MNG_ID")); 
				l_cd 		= String.valueOf(ht_s2.get("RENT_L_CD")); 
				mng_id = String.valueOf(ht_s2.get("MNG_ID")); 
				s_cd 		= String.valueOf(ht_s2.get("RENT_S_CD"));		
				rent_st = String.valueOf(ht_s2.get("RENT_ST"));
			}
		}else{
			result[i] = "고객이 중복 검색되어 일괄 등록에서 제외되었습니다. 직접 등록해주세요.";
			continue;			
		}

		if(c_id.equals("null")){
				result[i] = "등록 중 오류 발생";
				continue;
			}

			f_bean.setFine_st		("1");
			f_bean.setVio_dt		(value3[i] ==null?"":value3[i]); //위반일자
			f_bean.setVio_pla		(value4[i] ==null?"":value4[i]); //위반장소
			f_bean.setVio_cont		(value11[i] ==null?"":value11[i]); //위반내용
			f_bean.setPaid_st		("1");		//납부자변경
			f_bean.setPaid_end_dt	(value6[i] ==null?"":value6[i]); //납부기한
			f_bean.setPaid_amt		(value7[i] ==null?0: AddUtil.parseDigit(value7[i]));  //부과금액
			f_bean.setPol_sta		(gov_nm);  //청구기관-경기남부도로(주)
			f_bean.setPaid_no		(value8[i] ==null?"":value8[i]);  //고지서번호
			f_bean.setFault_st		("1");  //과실구분
			f_bean.setNote			("위택스 엑셀 일괄 등록");
			f_bean.setUpdate_id		(user_id);
			f_bean.setUpdate_dt		(AddUtil.getDate());
			f_bean.setMng_id		(mng_id);
			f_bean.setCar_mng_id	(c_id);
			f_bean.setRent_mng_id	(m_id);
			f_bean.setRent_l_cd		(l_cd);
			f_bean.setRent_s_cd		(s_cd);
			f_bean.setReg_id		(user_id);
			f_bean.setNotice_dt		(AddUtil.getDate());
			f_bean.setRent_st		(rent_st);
			
			//중복체크
			Vector c_fines = a_fdb.getFineCheckList(f_bean.getCar_mng_id(), f_bean.getVio_dt());
			int c_fine_size = c_fines.size();
			
			if(c_fine_size==0){
				seq = a_fdb.insertForfeit(f_bean);
				result[i] = "정상 처리되었습니다.";
				// 미등록 리스트 플래그 변경
		   		HashMap<String, Object> map= new HashMap<>();
		   		map.put("paid_no",value8[i]);
				
				a_fdb.updateFineTemp2RegYn((String)map.get("paid_no"));
				
			}else{
				for (int j = 0 ; j < 1 ; j++){
        	Hashtable c_fine = (Hashtable)c_fines.elementAt(j);
        	seq = AddUtil.parseInt(String.valueOf(c_fine.get("SEQ_NO")));
        	boolean flag6 = a_fdb.updateForfeitReReg(f_bean.getCar_mng_id(), seq, f_bean.getUpdate_id());
        	result[i] = "이미 등록된 과태료입니다.";
        }
			}
	
			if(seq > 0){
// 				result[i] = "정상 처리되었습니다.";
			}else{
				result[i] = "오류 발생!";
			}			
	
	}
	String ment = "";
	for(int i=start_row ; i < value_line ; i++){
		if(!result[i].equals("")) ment += result[i]+"";
	}
	int result_cnt = 0;
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>엑셀 파일 읽어 과태료(청구)내역서 등록하기
</p>
<form action="fine_wetax_excel_result.jsp" method='post' name="form1">
<input type='text' name='start_row' value='<%=start_row%>'>
<input type='text' name='value_line' value='<%=value_line%>'>
<%	for(int i=start_row ; i < value_line ; i++){
// 		if(result[i].equals("정상 처리되었습니다.")) continue;
		result_cnt++;%>
<input type='text' name='car_no'     value='<%=value5[i] ==null?"":value5[i]%>'>
<input type='text' name='js_dt'     value='<%=value3[i] ==null?"":value3[i]%>'>
<input type='text' name='result'     value='<%=result[i]%>'>
<%	}%>
<input type='text' name='result_cnt' value='<%=result_cnt%>'>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--		
		document.form1.submit();

//-->

</SCRIPT>
</BODY>
</HTML>