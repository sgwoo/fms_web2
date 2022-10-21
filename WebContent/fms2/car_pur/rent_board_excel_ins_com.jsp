<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.car_register.*, acar.insur.*, acar.cont.*, acar.client.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	InsComDatabase ic_db = InsComDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	String ins_com_id = request.getParameter("ins_com_id")==null?"":request.getParameter("ins_com_id");
	
	String vid[] 	= request.getParameterValues("ch_cd");
	int vid_size = vid.length;
	
	String vid_num		= "";
	String rent_mng_id 	= "";
	String rent_l_cd 	= "";
	int    count = 0;
	int flag = 0;
	String firm_nm =""; 
	
	String com_emp_yn ="";
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<body>
<table border="1" cellspacing="0" cellpadding="0" width=700>
	<tr>
		<td width='50' align='center' style="font-size : 8pt;">연번</td>
		<td width='150' align='center' style="font-size : 8pt;">계약번호</td>
	  <td width='500' align='center' style="font-size : 8pt;">처리결과</td>
	</tr>
	<%	for(int i=0;i < vid_size;i++){
				rent_l_cd = vid[i];

				String gubun = "가입";
				String car_no = "";
				String car_num = "";
				String result = "";
				
				Hashtable ht = a_db.getRentBoardSubCase(rent_l_cd);
				
				Hashtable cont_ht = a_db.getContCase(rent_l_cd);
				
				rent_mng_id = String.valueOf(cont_ht.get("RENT_MNG_ID"));
				

				
				
				CarRegBean cr_bean = new CarRegBean();
				
				//새차(1),중고차(2),재리스(0)				
				if(String.valueOf(cont_ht.get("CAR_MNG_ID")).equals("")){
					car_no  = String.valueOf(ht.get("EST_CAR_NO"));
					car_num = String.valueOf(ht.get("CAR_NUM"));
				}else{
					cr_bean = crd.getCarRegBean(String.valueOf(cont_ht.get("CAR_MNG_ID")));
					car_no  = cr_bean.getCar_no();
					car_num = cr_bean.getCar_num();
				}
				car_no  = AddUtil.replace(car_no," ","");
				car_num = AddUtil.replace(car_num," ","");
				
				//계약기본정보
				ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
				//고객정보
				ClientBean client = al_db.getNewClient(base.getClient_id());
				
				//보험사분류
				ins_com_id = "0038";
				
				//리스 업무용 : 삼성화재
				if(base.getCar_st().equals("3")){
					ins_com_id = "0007";
				//렌트,월렌트,보유차 : 영업용
				}else{
					//렌트 영업용 법인고객 : 동부화재
					if(base.getCar_st().equals("1") && client.getClient_st().equals("1")){
						//LPG
						if(String.valueOf(ht.get("DIESEL_YN")).equals("2")){
						//	ins_com_id = "0008";
						}
						//RV
						if(String.valueOf(ht.get("S_ST2")).equals("400") || String.valueOf(ht.get("S_ST2")).equals("401") || String.valueOf(ht.get("S_ST2")).equals("402") || String.valueOf(ht.get("S_ST2")).equals("501") || String.valueOf(ht.get("S_ST2")).equals("502") || String.valueOf(ht.get("S_ST2")).equals("601") || String.valueOf(ht.get("S_ST2")).equals("602")){
						//	ins_com_id = "0008";
						}
					}
				}	
				
				
				//차대번호나 차량번호 있는거 확인
				if(car_no.equals("") && car_num.equals("")){
					result = "차대번호와 차량번호가 없습니다.";
				}
				
				//차대번호나 차량번호 있는거 확인
				if(car_no.length() < 7 && car_num.length() < 17){
					result = "차대번호와 차량번호가 잘못 입력되었습니다. car_no="+car_no+"/len="+car_no.length()+"/car_num="+car_num+"/len="+car_num.length();
				}
				
				//영업용 확인
				if(result.equals("") && ins_com_id.equals("0038") && String.valueOf(cont_ht.get("CAR_ST")).equals("3")){
					//result = "리스계약입니다.";
				}
				
				//중복체크
				if(result.equals("")){
					int over_cnt = ic_db.getCheckOverInsExcelCom(gubun, "", rent_mng_id, rent_l_cd, "", "");
					if(over_cnt > 0){
						result = "이미 등록되어 있습니다.";
					}
				}
				
				ContEtcBean cont_etc =  a_db.getContEtcGrtSuc(rent_mng_id,rent_l_cd);
				
				//고객피보험자
				if(result.equals("") && ins_com_id.equals("0038") && cont_etc.getInsur_per().equals("2")){
					result = "고객피보험 계약입니다.";
				}
				
				
				//보험사엑셀관리에 등록
				if(result.equals("")){
						
						Hashtable ht2 = ec_db.getRentBoardIns(rent_mng_id, rent_l_cd);
						
						InsurExcelBean ins = new InsurExcelBean();
						
						ins.setReg_code		(reg_code);
						ins.setSeq				(count+1);
						ins.setReg_id			(ck_acar_id);
						ins.setGubun			(gubun);
						ins.setRent_mng_id(rent_mng_id);
						ins.setRent_l_cd	(rent_l_cd);
						
						ins.setValue01		(String.valueOf(ht2.get("FIRM_NM")));
						
						ins.setValue27		(String.valueOf(cont_ht.get("CAR_GU")));		
						
						if(String.valueOf(ht2.get("CAR_ST")).equals("업무대여")){
							ins.setValue01	("(주)아마존카/"+String.valueOf(ht2.get("FIRM_NM")));
						}
						
						ins.setValue02		(AddUtil.ChangeEnpH(String.valueOf(ht2.get("SSN"))));
						ins.setValue03		(String.valueOf(ht2.get("CAR_NM"))+" "+String.valueOf(ht2.get("CAR_NAME")));
						ins.setValue04		(String.valueOf(ht2.get("CAR_NO")));
						ins.setValue05		(String.valueOf(ht2.get("CAR_NUM")));
						
						ins.setValue06		(String.valueOf(ht2.get("TOT_AMT")));
						
						String driving_age = String.valueOf(ht2.get("DRIVING_AGE"));
						String driving_age_nm = "";
						if(driving_age.equals("0")){      driving_age_nm = "26세이상";
						}else if(driving_age.equals("3")){driving_age_nm = "24세이상";
						}else if(driving_age.equals("1")){driving_age_nm = "21세이상";
						}else if(driving_age.equals("5")){driving_age_nm = "30세이상";
						}else if(driving_age.equals("6")){driving_age_nm = "35세이상";
						}else if(driving_age.equals("7")){driving_age_nm = "43세이상";
						}else if(driving_age.equals("8")){driving_age_nm = "48세이상";
						}else if(driving_age.equals("9")){driving_age_nm = "22세이상";
						}else if(driving_age.equals("10")){driving_age_nm = "28세이상";
						}else if(driving_age.equals("11")){driving_age_nm = "35세이상~49세이하";
						}else if(driving_age.equals("2")){driving_age_nm = "모든운전자";
						}
						ins.setValue07		(driving_age_nm);
						
						String gcp_kd = String.valueOf(ht2.get("GCP_KD"));
						String gcp_kd_nm = "";
						if(gcp_kd.equals("1")){      gcp_kd_nm = "5천만원";
						}else if(gcp_kd.equals("2")){gcp_kd_nm = "1억원";
						}else if(gcp_kd.equals("3")){gcp_kd_nm = "5억원";
						}else if(gcp_kd.equals("4")){gcp_kd_nm = "2억원";
						}else if(gcp_kd.equals("8")){gcp_kd_nm = "3억원";
						}
						ins.setValue08		(gcp_kd_nm);
						
						String bacdt_kd = String.valueOf(ht2.get("BACDT_KD"));
						String bacdt_kd_nm = "";
						if(bacdt_kd.equals("1")){      bacdt_kd_nm = "5천만원";
						}else if(bacdt_kd.equals("2")){bacdt_kd_nm = "1억원";
						}
						ins.setValue09		(bacdt_kd_nm);
						
						ins.setValue10		(String.valueOf(ht2.get("COM_EMP_YN")));
						
						ins.setValue11		(String.valueOf(ht2.get("B_COM_NM"))+"-"+String.valueOf(ht2.get("B_MODEL_NM")));
						
						if(!String.valueOf(ht2.get("B_MODEL_NM")).equals("") && AddUtil.parseDecimal(String.valueOf(ht2.get("B_AMT"))).equals("0")){
							ins.setValue12	("92727");
						}else{
							ins.setValue12	(String.valueOf(ht2.get("B_AMT")));
						}
						ins.setValue13		(String.valueOf(ht2.get("B_SERIAL_NO")));
						ins.setValue14		(ins_com_id);
						
						//if(!ins_com_id.equals("")){
						//	ins.setValue14		(ins_com_id);
						//}
						
						if(String.valueOf(ht2.get("B_SERIAL_NO")).equals("") && AddUtil.parseDecimal(String.valueOf(ht2.get("B_AMT"))).equals("0")){
							ins.setValue11	("");
						}
						
					/* System.out.println(String.valueOf(ht2.get("LKAS_YN")));  
					System.out.println(String.valueOf(ht2.get("LDWS_YN")));  
					System.out.println(String.valueOf(ht2.get("ABS_YN")));   
					System.out.println(String.valueOf(ht2.get("FCW_YN")));   
					System.out.println(String.valueOf(ht2.get("EV_YN")));    
						 */
						ins.setValue28	(String.valueOf(ht2.get("LKAS_YN")));
						ins.setValue29	(String.valueOf(ht2.get("LDWS_YN")));
						ins.setValue30	(String.valueOf(ht2.get("AEB_YN")));
						ins.setValue31	(String.valueOf(ht2.get("FCW_YN")));
						ins.setValue32	(String.valueOf(ht2.get("EV_YN")));
						ins.setValue37	(String.valueOf(ht2.get("HOOK_YN")));
						ins.setValue38	(String.valueOf(ht2.get("LEGAL_YN")));
						
						if(String.valueOf(ht2.get("COM_EMP_YN")).equals("가입")){
							com_emp_yn = "Y";
						}else if(String.valueOf(ht2.get("COM_EMP_YN")).equals("미가입")){
							com_emp_yn = "N";
						}else{
							com_emp_yn = "N";
						}
						
						//계약관리 임직원운전한정특약 고객요청 으로 변경될때 (COM_EMP_SAC_ID와 COM_EMP_YN 확인)-20200709 보험담당자 요청
						if(!cont_etc.getCom_emp_sac_id().equals("")){
							if(!cont_etc.getCom_emp_yn().equals("")){
								com_emp_yn= cont_etc.getCom_emp_yn();
							}
						}
						
						ins.setValue26 (com_emp_yn);
						
						
						 firm_nm = ins.getValue01().replaceAll("\\(주\\)","")
								 .replaceAll("\\(주","")
								 .replaceAll("주\\)","")
								 .replaceAll("주식회사","")
								 .replaceAll("농업회사법인","")
								 .replaceAll("\\(농\\)","")
								 .replaceAll("유한회사","")
								 .replaceAll("\\(유\\)","")
								 .replaceAll("세무법인","")
								 .replaceAll("통일감정평가법인","")
								 .replaceAll("사단법인","")
								 .replaceAll(" ","");
						
						 if(firm_nm.length() > 10) firm_nm = firm_nm.substring(0,10);
						 
						 ins.setValue33		(firm_nm);
						 
						 //용도구분
						 int noLength = 0 ;
						 if(String.valueOf(ht2.get("CAR_NO")).equals("")) noLength = String.valueOf(ht2.get("CAR_NO")).length();
						 String tempCarNo = "";
						 if(noLength != 0)tempCarNo = String.valueOf(ht2.get("CAR_NO")).substring(noLength-5,noLength-5+1);
						 if(base.getCar_st().equals("3")){
							 	if(tempCarNo.startsWith("하") || tempCarNo.startsWith("허") || tempCarNo.startsWith("호")){
							 		ins.setValue34		("1");
							 	}else{
							 		ins.setValue34		("2");
							 	}
						 }else{
						 		ins.setValue34		("1");
						 } 

						 ins.setValue35	(String.valueOf(ht2.get("CLIENT_ST")));
						 
						//블랙박스 빌트 캡 변경 (렌터카공제조합만)
						if(!String.valueOf(ht2.get("OPT")).equals("") && String.valueOf(ht2.get("OPT")).replaceAll(" ","").contains("빌트인")){
							ins.setValue11		("내장형블랙박스");
							ins.setValue12		("0");
							ins.setValue13		("내장형블랙박스");
						}
						 
						if(String.valueOf(ht2.get("CAR_COMP_ID")).equals("0056")){
								ins.setValue11		("내장형블랙박스");
								ins.setValue12		("0");
								ins.setValue13		("내장형블랙박스");
						}
						 
						 
						if(ins.getValue01().equals("null") && ins.getValue02().equals("null") && ins.getValue03().equals("null null") && ins.getValue04().equals("null") && ins.getValue05().equals("null")){
							result = "계약내용을 정상적으로 가져오지 못했습니다.";
						}else{
						
							 if(!ic_db.insertInsExcelCom(ins)){
								flag += 1;
								result = "등록에러입니다.";
							}else{
							
								result = "정상 등록되었습니다.";
								count++;
							} 
						}

				}
				
	%>
	<tr>
		<td align='center' style="font-size : 8pt;"><%=i+1%></td>
    <td align='center' style="font-size : 8pt;"><%=rent_l_cd%></td>
    <td align='center' style="font-size : 8pt;"><%if(!result.equals("정상 등록되었습니다.")){%><font color=red><%=result%></font><%}else{%><%=result%><%}%></td>
	</tr>
	<%	}%>
</table>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>

