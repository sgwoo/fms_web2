<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*,java.text.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.insur.*, acar.cont.*"%> 
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<!--Grid-->
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/dhtmlxgrid.css" />
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/skins/web/dhtmlxgrid_rendering.css"/>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_deprecated.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_export.js"></script>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String dt = request.getParameter("dt")==null?"":request.getParameter("dt");		
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	boolean result =false;
	if(!st_dt.equals("")) st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) end_dt = AddUtil.replace(end_dt, "-", "");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsComDatabase ic_db = InsComDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	//System.out.println(dt+","+st_dt+","+end_dt+","+gubun1+","+gubun2+","+t_wd);
	
	String result_value = "";
	
	Vector jarr = ai_db.getInsChangeList3(dt,st_dt,end_dt,gubun1,gubun2,t_wd);
	int jarr_size = 0;
	
	jarr_size = jarr.size();
	
	String nn= "";
	String cont_bk = "";
	String ch_item = "";
	String jobjString = "";
	String car_no = "";
	String car_no2 = "";
	int bgcolor_count = 0;
	int bgcolor_count2 = 0;
	String reg_dt ="";
	int com_over_cnt = 0;
	
	 Date d = new Date();
	 Date t = new Date(d.getTime()+(1000*60*60*24*+1));
	 SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	 String sysdate =   sdf.format(d);	
	 String tomorrow =   sdf.format(t);	
	
	int count = 0;
	%>
	</head>
	<body leftmargin="15">
	<form action="/acar/ins_mng/ins_c2_frame.jsp" id="form1" name="form1" method="POST" target="c_foot">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="br_id" value="<%=br_id%>">
	<input type="hidden" name="user_id" value="<%=user_id%>">
	<input type='hidden' name='dt' value='<%=dt%>'>
	<input type='hidden' name='st_dt' value='<%=st_dt%>'>
	<input type='hidden' name='end_dt' value='<%=end_dt%>'>
	<input type='hidden' name='gubun1' value='<%=gubun1%>'>
	<input type='hidden' name='gubun2' value='<%=gubun2%>'>
	<input type='hidden' name='t_wd' value='<%=t_wd%>'>
	
	<table border="1" cellspacing="0" cellpadding="0" width=700>
	<tr>
		<td width='50' align='center' style="font-size : 8pt;">연번</td>
		<td width='100' align='center' style="font-size : 8pt;">계약번호</td>
		<td width='250' align='center' style="font-size : 8pt;">처리결과</td>
		<td width='100' align='center' style="font-size : 8pt;">등록코드</td>
		<td width='50' align='center' style="font-size : 8pt;">시퀀스</td>
		<td width='50' align='center' style="font-size : 8pt;">결과</td>
	</tr>  	
	
	<%
	
	if(jarr_size > 0) {

		for(int i = 0 ; i < jarr_size ; i++) {
			result =false;
				
			Hashtable ht = (Hashtable)jarr.elementAt(i);
			
				if(!String.valueOf(ht.get("VALUE01")).equals("추가 등록건") && !String.valueOf(ht.get("VALUE01")).equals("업무보험미가입")){
					//변경1 대여차량 중 임차인 변경일 경우 리스는 제외
					if(String.valueOf(ht.get("VALUE01")).equals("변경1 대여차량") && String.valueOf(ht.get("VALUE06")).equals("임차인")){
						if(String.valueOf(ht.get("CAR_ST")).equals("3")){ 
						//	boolean insExCh = ai_db.changeInsExcel(String.valueOf(ht.get("REG_CODE")), String.valueOf(ht.get("SEQ")), "Y");
							continue;
						}
					}
					
					if(!String.valueOf(ht.get("VALUE01")).equals("지연대차등록 임직원전용보험") ){
						if(!String.valueOf(ht.get("VALUE01")).equals("계약승계 등록")){	
							if( String.valueOf(ht.get("VALUE06")).equals("임직원임차인") ||	String.valueOf(ht.get("VALUE06")).equals("임차인")){
								if(!String.valueOf(ht.get("VALUE01")).contains("변경1")){
									//boolean insExCh = ai_db.changeInsExcel(String.valueOf(ht.get("REG_CODE")), String.valueOf(ht.get("SEQ")), "Y");
									continue;
								}
							}
						}
					}
									
					
					// 임직원운정한정과 BASE임차인정보 리스트가 2개 나오는경우, 임직원운전한정 리스트에서 빼기
					
					if( String.valueOf(ht.get("VALUE06")).equals("임직원운전한정")){
						 int over_cnt =  ic_db.getCheckOverInsExcel(String.valueOf(ht.get("CAR_MNG_ID")));
						if(over_cnt > 1){
							//boolean insExCh = ai_db.changeInsExcel(String.valueOf(ht.get("REG_CODE")), String.valueOf(ht.get("SEQ")), "Y");
							continue;
						} 
					}
					
					
					//동부화재 임차인 리스트에서 빼기
					if(!String.valueOf(ht.get("VALUE01")).equals("지연대차등록 임직원전용보험") ){
						if(!String.valueOf(ht.get("INS_CON_NO")).contains("P")){
							if(String.valueOf(ht.get("VALUE06")).equals("임차인")){
								//boolean insExCh = ai_db.changeInsExcel(String.valueOf(ht.get("REG_CODE")), String.valueOf(ht.get("SEQ")), "Y");
								continue;
							}
						}
					}
					
					
					/*연장대여개시일이 오늘 날짜보다 후이면 보이지 않게 (20190412 요청건) */
					String fee_rent_start_dt = "";
					int fee_size = af_db.getMaxRentSt(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")));
					for(int j = 0; j < fee_size; j++){
						ContFeeBean ext_fee = a_db.getContFeeNew(String.valueOf(ht.get("RENT_MNG_ID")) , String.valueOf(ht.get("RENT_L_CD")), Integer.toString(j+1));
						if(!ext_fee.getCon_mon().equals("")){
							if(j>0){
								fee_rent_start_dt = ext_fee.getRent_start_dt();
							}
						}
					}
					if(!fee_rent_start_dt.equals("")){
						if(Integer.parseInt(fee_rent_start_dt) > Integer.parseInt(sysdate)){
							continue;
						} 
					}
					
					//재리스 대여차량인도 탁송의뢰 등록 일때만 차량인도일 여부확인
						//계약기타정보
						ContEtcBean cont_etc = a_db.getContEtc(String.valueOf(ht.get("RENT_MNG_ID")) ,String.valueOf(ht.get("RENT_L_CD")) );
						
					/* 차량인도일자가 없는 경우 리스트에 안나오게  -아래요청으로 변경됨*/
					/* 모든 차량 차량인도일 또는 차량인도예정일 뜨게하고 없으면 
					      계약일자로 찾은 다음 찾은 날짜 기준으로 전날 리스트에 나오도록- 2020616 보험담당자요청 */
					/* 대여개시일도 추가 1.차량인도일 2.차량인도예정일 3.대여개시일 4.계약일   */
						String stand_dt = "";
						if(!cont_etc.getCar_deli_dt().equals("")){
							stand_dt = cont_etc.getCar_deli_dt();
						}else if(!cont_etc.getCar_deli_est_dt().equals("")){
								stand_dt = cont_etc.getCar_deli_est_dt();
						}else if(!fee_rent_start_dt.equals("")){
							stand_dt = fee_rent_start_dt;
						}else{
							stand_dt = String.valueOf(ht.get("RENT_DT"));
						}
						
						//전날부터 보이기
					 	/* if(Integer.parseInt(stand_dt) > (Integer.parseInt(tomorrow))){
							//System.out.println(String.valueOf(ht.get("CAR_NO"))+" "+stand_dt);
							continue;
						}	*/
					 	
	 	 			 	SimpleDateFormat sdf2 = new SimpleDateFormat("yyyyMMdd");
			 			Date stand_dt_date =   sdf2.parse(stand_dt);
			 			Date stand_dt_yesterdate = new Date(stand_dt_date.getTime()-(1000*60*60*24*+1));
		 			 	String stand_dt_yesterday = sdf2.format(stand_dt_yesterdate);
					
		 			 	//공휴일/주말일 경우 전날로 처리
		 			 	stand_dt_yesterday = ai_db.getValidDt(stand_dt_yesterday).replaceAll("-", "");
		 			 	
		 			 	if(Integer.parseInt(stand_dt_yesterday) > (Integer.parseInt(sysdate))){
							//System.out.println(String.valueOf(ht.get("CAR_NO"))+" "+stand_dt_yesterday + ":" + sysdate);
							continue;
						}   
		 			 	
						//USE_YN 이 null 값일 경우 (승계가 진행중이므로 아직 결재 완료가 안된건)
						if(String.valueOf(ht.get("USE_YN")).equals("") ){
							continue;
						}
						
						//개인인 경우 임직원이 N이여야 하지만 고객요청시에는 Y가능
						/* if(!String.valueOf(ht.get("CLIENT_ST")).equals("1") && !String.valueOf(ht.get("CLIENT_ST")).equals("3")){
							if(cont_etc.getCom_emp_yn().equals("Y")){
								if(cont_etc.getCom_emp_sac_id().equals("")){
									continue;
								}
							}
						} */
				}
				
				// 중복되는 리스트 제거
				//if(	ic_db.getCheckOverInsExcel( String.valueOf(ht.get("CAR_MNG_ID")), String.valueOf(ht.get("VALUE07")),String.valueOf(ht.get("VALUE08"))) > 1 ) continue;
				
				count++;
				
				String reg_code =  (String)ht.get("REG_CODE");
				int seq = Integer.parseInt((String)ht.get("SEQ"));
				
				//중복 체크
				int over_cnt =  ic_db.getCheckOverInsExcelCom("배서", reg_code, (String)ht.get("SEQ"));
				if(over_cnt > 0){
					result_value = "이미 처리된 건 입니다";
				}
				
				
				if(String.valueOf(ht.get("VALUE06")).equals("보험계약자")) {
				    if(ht.get("CONR_NM").equals(ht.get("value08"))) {
				        result_value = "기반영으로 처리된건입니다";
				        over_cnt = 1;
				    }
				}
				
				/* if(String.valueOf(ht.get("VALUE06")).equals("피보험자")) {
				    if(ht.get("CON_F_NM").equals(ht.get("value08"))) {
				        result_value = "기반영으로 처리된건입니다";
				        over_cnt = 1;
				    }
				} */
				
				if(String.valueOf(ht.get("VALUE06")).equals("연령범위") || String.valueOf(ht.get("VALUE06")).equals("연령변경")
						|| String.valueOf(ht.get("VALUE06")).equals("연령")) {
				    if(ht.get("AGE_SCP").equals(ht.get("VALUE08"))) {
				        result_value = "기반영으로 처리된건입니다";
				        over_cnt = 1;
				    }
				}
				
				if(String.valueOf(ht.get("VALUE06")).equals("대물가입금액") || String.valueOf(ht.get("VALUE06")).equals("대물배상")
						|| String.valueOf(ht.get("VALUE06")).equals("대물")) {
				    if(ht.get("VINS_GCP_KD").equals(ht.get("VALUE08"))) {
				        result_value = "기반영으로 처리된건입니다";
				        over_cnt = 1;
				    }
				}
				
				if(String.valueOf(ht.get("VALUE06")).equals("자기신체사고")) {
				        result_value = "기반영으로 처리된건입니다";
				        over_cnt = 1;
				}
				
			    if( String.valueOf(ht.get("VALUE06")).equals("블랙박스") ) {
			        //if(ht.get("BLACKBOX_YN").equals("y") || ht.get("BLACKBOX_YN").equals("Y"))
					String ins_value = "";
			        String blackbox_nm = String.valueOf(ht.get("BLACKBOX_NM"));
			       	if( blackbox_nm.contains(" ") ) blackbox_nm = blackbox_nm.replace(" ", "/");
					if( blackbox_nm.contains("-") ) blackbox_nm = blackbox_nm.replace("-", "/");
			       	String blackbox_no = String.valueOf(ht.get("BLACKBOX_NO"));
			       	ins_value = "장착/" + blackbox_nm + "/" + blackbox_no;
			       	
			       	if( String.valueOf(ht.get("VALUE08")).equals(ins_value) ){
			       		result_value = "기반영으로 처리된건입니다";
			            over_cnt = 1;
			       	} else if( ic_db.getCheckOverInsExcelCom(String.valueOf(ht.get("CAR_MNG_ID")), String.valueOf(ht.get("INS_ST")), String.valueOf(ht.get("VALUE07")), String.valueOf(ht.get("VALUE08"))) > 0){
			       		result_value = "이미 처리된 건입니다.";
			       		over_cnt = 1;
			       	}
			    }
				
				if(String.valueOf(ht.get("VALUE06")).equals("임직원운전한정") || String.valueOf(ht.get("VALUE06")).equals("임직원한전운전특약") 
						||String.valueOf(ht.get("VALUE06")).equals("임직원한정운전특약") || String.valueOf(ht.get("VALUE06")).equals("임직원")) {
				    if(ht.get("COM_EMP_YN").equals(ht.get("VALUE08"))) {
				        result_value = "기반영으로 처리된건입니다";
				        over_cnt = 1;
				    }
				}
				
				if(String.valueOf(ht.get("VALUE06")).equals("임직원임차인") || String.valueOf(ht.get("VALUE06")).equals("임차인")) {
				    if(ht.get("FIRM_EMP_NM").equals(ht.get("VALUE08"))) {
				        result_value = "기반영으로 처리된건입니다";
				        over_cnt = 1;
				    }
				}
				
				/* if(!String.valueOf(ht.get("INS_CON_NO")).contains("P")){
					result_value = "동부화제에 관련된 건 입니다";
			        over_cnt = 1;
				} */
				
				//ins_com_excel 기존 중복값 확인
				if(!String.valueOf(ht.get("VALUE06")).equals("임직원운전한정") && !String.valueOf(ht.get("VALUE06")).equals("임직원한전운전특약") 
						&& !String.valueOf(ht.get("VALUE06")).equals("임직원한정운전특약") && !String.valueOf(ht.get("VALUE06")).equals("임직원")
						&& !String.valueOf(ht.get("VALUE06")).equals("연령범위") && !String.valueOf(ht.get("VALUE06")).equals("연령변경")
						&& !String.valueOf(ht.get("VALUE06")).equals("연령")
					) 
				{
					
					com_over_cnt =  ic_db.getCheckOverInsExcelCom2(String.valueOf(ht.get("INS_CON_NO")),String.valueOf(ht.get("ENP_NO")),String.valueOf(ht.get("CAR_MNG_ID")),String.valueOf(ht.get("VALUE07")),String.valueOf(ht.get("VALUE08")));
					if(com_over_cnt > 0){ 
						 result_value = "완료처리가 끝난 건입니다";
						 over_cnt = 1;
					}
				}
				
				if(String.valueOf(ht.get("VALUE13")).contains("/") ){
					String insInfo[] = String.valueOf(ht.get("VALUE13")).split("/");
					String firm_emp_nm ="";
					String enp_no ="";
					String age_scp ="";
					String vins_gcp_kd ="";
					String com_emp_yn ="";
					
					if(insInfo.length == 7){// '/' 구분자가 7개로 나눠져있을때
						firm_emp_nm = insInfo[0]+"/"+insInfo[1];      
						enp_no = insInfo[2];  
						age_scp = insInfo[3];      
						vins_gcp_kd = insInfo[4];      
						com_emp_yn = insInfo[5];      

					}else if(insInfo.length == 6){ //'/' 구분자가 6개로 나눠져있을때
						firm_emp_nm = insInfo[0];     
						enp_no = insInfo[1];  
						age_scp = insInfo[2];      
						vins_gcp_kd = insInfo[3];      
						com_emp_yn = insInfo[4];     
					}
					 
					if(ht.get("FIRM_EMP_NM").equals(firm_emp_nm) && ht.get("INS_ENP_NO").equals(enp_no)
						&& ht.get("AGE_SCP").equals(age_scp) && ht.get("VINS_GCP_KD").equals(vins_gcp_kd)
						&& ht.get("COM_EMP_YN").equals(com_emp_yn)) {
					        result_value = "기반영으로 처리된건입니다";
					        over_cnt = 1;
					}
				}
				
			
			if(over_cnt > 0){
			}else{
				result = ic_db.call_sp_ins_cng_req_com(reg_code,seq);
				if(!result){
					result_value = "등록 에러입니다.";	
				}else{
				/* 	if(String.valueOf(ht.get("REG_CODE")).equals("ICQ-A33381CDEFGHIJKL")){
					} */
					
					result_value = "정상 등록되었습니다.";	
				}
			} 
			%>
			<tr>
				<td align='center' style="font-size : 8pt;"><%=count%></td>
			    <td align='center' style="font-size : 8pt;"><%=ht.get("CAR_NO")%></td>
			    <td align='center' style="font-size : 8pt;"><%if(!result){%><font color=red><%=result_value%></font><%}else{%><%=result_value%><%}%></td>
			    <td align='center' style="font-size : 8pt;"><%=reg_code%></td>
			    <td align='center' style="font-size : 8pt;"><%=seq%></td>
			    <td align='center' style="font-size : 8pt;"><%=result%></td>
			</tr>

			<%
		//}
		}

	}
%>
		</table>
	</form>
</body>

</html>