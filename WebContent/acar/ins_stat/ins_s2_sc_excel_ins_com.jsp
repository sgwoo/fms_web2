<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.insur.*, acar.cont.*, acar.client.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	InsComDatabase ic_db = InsComDatabase.getInstance();
	InsEtcDatabase ie_db = InsEtcDatabase.getInstance();
	
	String ins_com_id = request.getParameter("ins_com_id")==null?"":request.getParameter("ins_com_id");
	
	String vid[] 	= request.getParameterValues("ch_cd");
	int vid_size = vid.length;
	
	String vid_num		= "";
	String rent_mng_id 	= "";
	String rent_l_cd 	= "";
	String car_mng_id 	= "";
	String ins_st 	= "";
	int    count = 0;
	int    tatalcount = 0;
	int flag = 0;
	String firm_nm =""; 
	int startNum = 0;
	int endNum = 0;
	
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
	
				vid_num = vid[i];
				
				rent_mng_id 	= vid_num.substring(0,6);
				rent_l_cd 		= vid_num.substring(6,19);
				car_mng_id 		= vid_num.substring(19,25);
				ins_st				= vid_num.substring(25);
				
			//	System.out.println(rent_mng_id);
				
				String gubun = "갱신";
				String result = "";
				startNum = 0;
				endNum = 0;
				
				
				//중복체크
				int over_cnt = ic_db.getCheckOverInsExcelCom(gubun, "", "", "", car_mng_id, ins_st);
				if(over_cnt > 0){
					result = "이미 등록되어 있습니다.";
				}
				
				//보험사엑셀관리에 등록
				if(result.equals("")){
						
					Hashtable ht2 = ie_db.getInsStat_excel(car_mng_id, ins_st);
					
					//계약기본정보
					ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
					//고객정보
					ClientBean client = al_db.getNewClient(base.getClient_id());
				
					//보험사분류
					ins_com_id = "0038";
					//자동차등록 자가용 : 동부화재
					if(String.valueOf(ht2.get("CAR_USE")).equals("업무용")){
						ins_com_id = "0007";
					//렌트,월렌트,보유차 : 영업용
					}else{
						//렌트 영업용 법인고객 : 동부화재
						if(base.getCar_st().equals("1") && client.getClient_st().equals("1")){
							//LPG
							if(String.valueOf(ht2.get("DIESEL_YN")).equals("2")){
							//	ins_com_id = "0008";
							}
							//RV
							if(String.valueOf(ht2.get("S_ST2")).equals("400") || String.valueOf(ht2.get("S_ST2")).equals("401") || String.valueOf(ht2.get("S_ST2")).equals("402") || String.valueOf(ht2.get("S_ST2")).equals("501") || String.valueOf(ht2.get("S_ST2")).equals("502") || String.valueOf(ht2.get("S_ST2")).equals("601") || String.valueOf(ht2.get("S_ST2")).equals("602")){
							//	ins_com_id = "0008";
							}
						}
						//해지 결재진행분은 아마존카로 한다.
	    				if(!(ht2.get("DOC_NO")+"").equals("") && !(ht2.get("FIRM_NM")+"").equals("(주)아마존카")){
	    					ins_com_id = "0038";
	    				}
					}
					
					
					InsurExcelBean ins = new InsurExcelBean();
					
					ins.setReg_code		(reg_code);
					ins.setSeq				(count+1);
					ins.setReg_id			(ck_acar_id);
					ins.setGubun			(gubun);
					ins.setRent_mng_id(rent_mng_id);
					ins.setRent_l_cd	(rent_l_cd);
					ins.setCar_mng_id	(car_mng_id);
					ins.setIns_st			(ins_st);
					
					ins.setValue01	(String.valueOf(ht2.get("INS_COM_NM")));
					ins.setValue02		("");
					ins.setValue03		(AddUtil.ChangeDate2(String.valueOf(ht2.get("INS_EXP_DT"))));
					ins.setValue04		(String.valueOf(ht2.get("CAR_NO")));
					ins.setValue05		(String.valueOf(ht2.get("CAR_NUM")));
					ins.setValue06		(String.valueOf(ht2.get("CAR_NM"))+" "+String.valueOf(ht2.get("CAR_NAME")));
					ins.setValue07		(String.valueOf(ht2.get("CAR_KD")));
					ins.setValue08		(String.valueOf(ht2.get("TAKING_P")));
					ins.setValue09		(AddUtil.ChangeDate2(String.valueOf(ht2.get("INIT_REG_DT"))));
					ins.setValue10		(String.valueOf(ht2.get("AIR")));
					ins.setValue11		(String.valueOf(ht2.get("AUTO")));
					ins.setValue12		(String.valueOf(ht2.get("ABS")));
					ins.setValue13		(String.valueOf(ht2.get("BLACKBOX")));
					ins.setValue14		(String.valueOf(ht2.get("AGE_SCP")));
					ins.setValue15		(String.valueOf(ht2.get("VINS_GCP_KD")));
					ins.setValue16		(String.valueOf(ht2.get("VINS_BACDT_KD")));
					ins.setValue17		(String.valueOf(ht2.get("VINS_BACDT_KC2")));
					ins.setValue18		(String.valueOf(ht2.get("VINS_CACDT2")));
					ins.setValue19		(String.valueOf(ht2.get("VINS_CANOISR2")));
					ins.setValue20		(String.valueOf(ht2.get("VINS_SPE2")));
					ins.setValue21		(String.valueOf(ht2.get("COM_EMP_YN")));
					ins.setValue22		("");
					ins.setValue23		(String.valueOf(ht2.get("FIRM_NM")));
					ins.setValue24		(String.valueOf(ht2.get("USER_NM")));
					ins.setValue25		(String.valueOf(ht2.get("ENP_NO")));
					ins.setValue26		(String.valueOf(ht2.get("RENT_START_DT"))+"~"+String.valueOf(ht2.get("RENT_END_DT")));
					ins.setValue27		(String.valueOf(ht2.get("B_COM_NM"))+"-"+String.valueOf(ht2.get("B_MODEL_NM")));
					ins.setValue28		(String.valueOf(ht2.get("B_AMT")));
					ins.setValue29		(String.valueOf(ht2.get("B_SERIAL_NO")));
					
					
					ins.setValue43		(String.valueOf(ht2.get("LKAS_YN")));
					ins.setValue44		(String.valueOf(ht2.get("LDWS_YN")));
					ins.setValue45		(String.valueOf(ht2.get("AEB_YN")));
					ins.setValue46		(String.valueOf(ht2.get("FCW_YN")));
					ins.setValue47		(String.valueOf(ht2.get("EV_YN")));
					//ins.setValue48		(String.valueOf(ht2.get("OTHERS")));
					ins.setValue48		(String.valueOf(ht2.get("OTHERS_DEVICE")));
					ins.setValue52		(String.valueOf(ht2.get("HOOK_YN")));
					ins.setValue53		(String.valueOf(ht2.get("LEGAL_YN")));
						
					ContEtcBean cont_etc =  a_db.getContEtc(rent_mng_id,rent_l_cd);
					
					//법률비용지원금
					if(cont_etc.getLegal_yn().equals("Y") && ins.getValue53().equals("Y")){
						ins.setValue53		("Y");
					}else{
						ins.setValue53		("N");
					}
					
					//계약관리 임직원운전한정특약 고객요청 으로 변경될때 (COM_EMP_SAC_ID와 COM_EMP_YN 확인)-20200709 보험담당자 요청
					/* if(!cont_etc.getCom_emp_sac_id().equals("")){
						if(!cont_etc.getCom_emp_yn().equals("")){
							ins.setValue21(cont_etc.getCom_emp_yn());
						}
					} */
						
						//해지 결재진행분은 아마존카로 한다.
    				if(!(ht2.get("DOC_NO")+"").equals("") && !(ht2.get("FIRM_NM")+"").equals("(주)아마존카")){
    					ins.setValue23("(주)아마존카");
    					ins.setValue25("1288147957");
    					ins.setValue14("26세이상");
    					ins.setValue15("1억원");
    					ins.setValue16("1억원");
    					ins.setValue21("N");
    				}
    				
    				if(!String.valueOf(ht2.get("B_COM_NM")).equals("") && !String.valueOf(ht2.get("B_MODEL_NM")).equals("") && AddUtil.parseDecimal(String.valueOf(ht2.get("B_AMT"))).equals("0")){
    					ins.setValue28("92727");
    				}
    				
					if(String.valueOf(ht2.get("BLACKBOX")).equals("0") && AddUtil.parseInt(ins.getValue28())>0){
						ins.setValue13	("1");
					}
					
					//시리얼번호가 없으면 블랙박스는 없다고 표시함
					if(ins.getValue29().equals("")){
						ins.setValue13	("0");
					}
					
					//ins.setValue30	("0038");
					ins.setValue30		(ins_com_id);
					
					//if(!ins_com_id.equals("")){
					//	ins.setValue30	(ins_com_id);
					//}
					
					
					if( String.valueOf(ht2.get("VALUE01")).equals("해지전 보험정리") || String.valueOf(ht2.get("VALUE01")).equals("계약해지 완료후 보험 관리 체크요망")
							||String.valueOf(ht2.get("VALUE01")).equals("계약해지 결재진행 보험 관리 요망") || String.valueOf(ht2.get("VALUE01")).equals("계약해지 보유차 관리 요망")	
							||String.valueOf(ht2.get("VALUE01")).equals("월렌트 계약해지 완료후 보험 관리 체크요망") || String.valueOf(ht2.get("VALUE01")).equals("26세이하 연령인 보유차 반차 통보")
							||String.valueOf(ht2.get("VALUE01")).equals("지연대차 반차 통보") 
								){
							firm_nm = "(주)아마존카";
							ins.setValue25("1288147957");
							if(String.valueOf(ht2.get("CAR_USE")).equals("영업용") && ins_com_id.equals("0008")){
								ins.setValue30		("0038");
							}
						}
					
					
					 firm_nm = ins.getValue23().replaceAll("\\(주\\)","")
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
					 
					 
					 ins.setValue49		(firm_nm);
					 
					 //용도구분
					 if(String.valueOf(ht2.get("CAR_USE")).equals("업무용")){
					 		ins.setValue50		("2");
					 }else{
					 		ins.setValue50		("1");
					 }					 
					 
					 ins.setValue51	(String.valueOf(ht2.get("CLIENT_ST")));
				//	 ins.setValue52	(String.valueOf(ht2.get("JG_CODE")));
					 
					//영업용 확인
					if(ins_com_id.equals("0038") && String.valueOf(ht2.get("CAR_USE")).equals("업무용")){
						//result = "자가용 차량입니다.";
					}
					//블랙박스 빌트 캡 변경 (렌터카공제조합만)
					if(!String.valueOf(ht2.get("OPT")).equals("") && String.valueOf(ht2.get("OPT")).replaceAll(" ","").contains("빌트인")){
						ins.setValue13		("1");
						ins.setValue27		("내장형블랙박스");
						ins.setValue28		("0");
						ins.setValue29		("내장형블랙박스");
					}
					//테슬라건은 모두 내장형으로
					if(String.valueOf(ht2.get("CAR_COMP_ID")).equals("0056")){
						ins.setValue13		("1");
						ins.setValue27		("내장형블랙박스");
						ins.setValue28		("0");
						ins.setValue29		("내장형블랙박스");
					}
					
				 	if(result.equals("")){
						if(!ic_db.insertInsExcelCom(ins)){
							flag += 1;
							result = "등록에러입니다.";
						}else{
							result = "정상 등록되었습니다.";
							count++;
						}

					} 
				}
			tatalcount++;
				
	%>
	<tr>
		<td align='center' style="font-size : 8pt;"><%=i+1%></td>
    	<td align='center' style="font-size : 8pt;"><%=rent_l_cd%></td>
		<td align='center' style="font-size : 8pt;"><%if(!result.equals("정상 등록되었습니다.")){%><font color=red><%=result%></font><%}else{%><%=result%><%}%></td> 
	</tr>
	<%	}%>
</table>
<script language='javascript'>
 var vid_size  = '<%=vid_size%>';
 var tatalcount  = '<%=tatalcount%>';
  
 if(vid_size == tatalcount){
	 opener.parent.location.reload();

 }

</script>
</body>
</html>

