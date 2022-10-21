<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,java.text.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.insur.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsComDatabase ic_db = InsComDatabase.getInstance();
	
	
	String vid[] 	= request.getParameterValues("ch_cd");
	int vid_size = vid.length;
	
	String vid_num		= "";
	String car_mng_id 	= "";
	String rent_mng_id 	= "";
	String rent_l_cd 	= "";
	String car_no 	= "";
	String ins_com_no="";
	int    count = 0;
	int flag = 0;
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	 Date d = new Date();
	 SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
 	 int sysdate =   Integer.parseInt(sdf.format(d));	
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
		<td width='100' align='center' style="font-size : 8pt;">차량번호</td>
		<td width='100' align='center' style="font-size : 8pt;">증권번호</td>
	  <td width='100' align='center' style="font-size : 8pt;">차량고유코드</td>
		<td width='150' align='center' style="font-size : 8pt;">계약번호</td>
	  <td width='500' align='center' style="font-size : 8pt;">처리결과</td>
	</tr>
	<%	for(int i=0;i < vid_size;i++){
	
				vid_num = vid[i];
				
				rent_mng_id 	= vid_num.substring(0,6);
				rent_l_cd 		= vid_num.substring(6,19);
				
				String gubun = "배서";
				String car_num = "";
				String result = "";
				
				//보험사엑셀관리에 등록
				Hashtable ht2 = d_db.getClsDocExcel(rent_mng_id, rent_l_cd);
						
				InsurExcelBean ins = new InsurExcelBean();
				
				car_no = String.valueOf(ht2.get("CAR_NO"));
				car_mng_id = String.valueOf(ht2.get("CAR_MNG_ID"));
				ins_com_no = String.valueOf(ht2.get("INS_CON_NO"));
				
				ins.setReg_code		(reg_code);
				ins.setSeq				(count+1);
				ins.setReg_id			(ck_acar_id);
				ins.setGubun			(gubun);
				ins.setRent_mng_id(rent_mng_id);
				ins.setRent_l_cd	(rent_l_cd);
				ins.setCar_mng_id	(String.valueOf(ht2.get("CAR_MNG_ID")));
				ins.setIns_st			(String.valueOf(ht2.get("INS_ST")));
						
				ins.setValue01		(String.valueOf(ht2.get("CAR_NO")));
				ins.setValue02		(String.valueOf(ht2.get("INS_CON_NO")));
				ins.setValue03		("(주)아마존카");
				ins.setValue04		(String.valueOf(ht2.get("CAR_NM")));
				ins.setValue05		("1288147957");
				ins.setValue06		(String.valueOf(ht2.get("INS_START_DT")));
				ins.setValue07		(String.valueOf(ht2.get("INS_EXP_DT")));
				
				String tempGubun="해지";
				
				String before = String.valueOf(ht2.get("FIRM_NM2")) +"/"+ String.valueOf(ht2.get("ENP_NO2"))
				 				+"/"+ String.valueOf(ht2.get("AGE_SCP")) +"/"+ String.valueOf(ht2.get("VINS_GCP_KD"))
				 				+"/"+ String.valueOf(ht2.get("BEFORE_EMP_YN")) +"/"+ String.valueOf(ht2.get("RENT_START_DT"))
				 				+"/"+ String.valueOf(ht2.get("RENT_START_DT"));
				
				
				String after1 ="";
				if(!String.valueOf(ht2.get("AGE_SCP")).equals("26세이상")){
					tempGubun = "연령";
					after1 = "26세이상";
				}
				if(!String.valueOf(ht2.get("VINS_GCP_KD")).equals("1억원")){
					if(!after1.equals("")){
						tempGubun = tempGubun+"/"+"대물";
						after1 = after1+"/"+"1억원";
					}else{
						tempGubun = "대물";
						after1 = "1억원";
					}
				}
				if(!String.valueOf(ht2.get("BEFORE_EMP_YN")).equals("미가입")){
					if(!after1.equals("")){
						tempGubun = tempGubun+"/"+"임직원";
						after1 = after1+"/"+"미가입";
					}else{
						tempGubun = "임직원";
						after1 = "미가입";
					}
				}
				ins.setValue08	(tempGubun);
				ins.setValue09	(before);
				String after2 =  "아마존카/1288147957/26세이상/1억원/미가입/"+String.valueOf(ht2.get("RENT_START_DT"));
				ins.setValue10	(after1);
				ins.setValue35	(after2);
				
				ins.setValue11		("장기임차인 변경, 해지");
				ins.setValue12		(AddUtil.getDate(4));
				
				ins.setValue14		(String.valueOf(ht2.get("INS_COM_ID")));
				ins.setValue28		("N");	
				ins.setValue36		("아마존카");
			//	ins.setValue39		("N"); //Hook_yn 
				ins.setValue40		("N"); //Legal_yn 
				
				if(String.valueOf(ht2.get("INS_CON_NO")).equals("")||String.valueOf(ht2.get("INS_CON_NO")).equals("null")){
					result = "가입한 보험이 없습니다.";
				}else{
				 	//ins_excel_com 중복체크
					int over_cnt = ic_db.getCheckOverInsExcelCom(gubun, "", rent_mng_id, rent_l_cd, ins.getCar_mng_id(), ins.getIns_st(), ins.getValue08(), ins.getValue09(), ins.getValue10(), ins.getValue11(), ins.getValue12());
					
					/*	
					//ins_excel_com 신규보험에 대한 배서현황의 중복체크 후 삭제
					if(over_cnt == 0){
						int ins_st = Integer.parseInt(ins.getIns_st());
						over_cnt = ic_db.getCheckOverInsExcelCom(ins.getCar_mng_id(), Integer.toString(ins_st));
						if(over_cnt == 1){
							boolean flag1 = ic_db.deleteInsExcelCom(ins.getCar_mng_id(), Integer.toString(ins_st));
							if(flag1){
								result = "배서현황 "+ins.getValue01()+"차량의 데이터 삭제 후 등록 되었습니다.";
								over_cnt = 0;
							}else{
								result = "배서현황 "+ins.getValue01()+"차량의 데이터 삭제가 실패하였습니다.";
							}
						}
						
					}
					
					//ins_excel 신규보험에 대한 배서2리스트의 중복체크 후 배서2리스트에서 삭제 
					if(over_cnt == 0){
						int ins_st = Integer.parseInt(ins.getIns_st());
						over_cnt = ic_db.getCheckOverInsExcel(ins.getCar_mng_id(), Integer.toString(ins_st));
						if(over_cnt == 1){
							boolean flag1 = ic_db.deleteInsExcel(ins.getCar_mng_id(), Integer.toString(ins_st));
							if(flag1){
								result = "배서2리스트 "+ins.getValue01()+"차량 데이터 삭제 후 등록 되었습니다.";
								over_cnt = 0;
							}else{
								result = "배서2리스트 "+ins.getValue01()+"차량 데이터 삭제가 실패하였습니다.";
							}
						}
					}
					 */
					 
					//1. 배서2 리스트에 있고, 증권번호가 같은 경우(차량번호, 증권번호)
					if(over_cnt == 0){
						int ins_st = Integer.parseInt(ins.getIns_st());
						over_cnt = ic_db.getCheckOverInsExcel(ins.getCar_mng_id(), Integer.toString(ins_st));
						if(over_cnt >0){
							result = "보험배서2에 이미 등록되어 있습니다.";
						}
					}
					
					//2. 배서2 리스트에 있고, 증권번호가 다른 데, 보험마감일이 지난 경우
					if(over_cnt == 0){
						int ins_exp_dt = Integer.parseInt(ins.getValue07()); 
						if(ins_exp_dt < sysdate){
							over_cnt = 1;
							result = "이미 보험마감일이 지난 건입니다.";
						}
					}
					
					//3. 이미 완료처리 되었고, 증권번호가 같을 경우(차량번호, 증권번호)
					if(over_cnt == 0){
						int ins_st = Integer.parseInt(ins.getIns_st());
						over_cnt = ic_db.getCheckOverInsExcelCom(ins.getCar_mng_id(), Integer.toString(ins_st));
						if(over_cnt == 1){
							result = "이미 완료처리 되었습니다.";
						}
					}
					//4. 이미 완료처리 되었고,증권번호가 다른 데, 보험마감일이 지난 경우 =  2번 로직과 동일 
					
					
					//5. 개시전/출고전 해지 대한 처리
					if(String.valueOf(ht2.get("CLS_ST")).equals("7")){
						over_cnt = 1;
						result = "출고전 해지 건 입니다.";
					}		
					
					if(String.valueOf(ht2.get("CLS_ST")).equals("10")){
						over_cnt = 1;
						result = "개시전 해지 건 입니다.";
					}
					
					//6. 동부화재이면서 해지인것들(동부화재 상호/사업자만 변경된건)
					 if(!String.valueOf(ht2.get("INS_CON_NO")).contains("P") && tempGubun.equals("해지")){
						over_cnt = 1;
						result = "동부화재이면서 상호/사업자번호만 변경된 건 입니다.";
					} 
							
					if(over_cnt > 0){
						if(result.equals("")) result = "이미 등록되어 있습니다.";
					}else{
						 if(!ic_db.insertInsExcelCom(ins)){
							flag += 1;
							result = "등록에러입니다.";
						}else{
							if(result.equals("")) result = "정상 등록되었습니다.";
							count++;
						} 
					if(result.equals("")) result = "정상 등록되었습니다.";
					}
					 
					
					
				}
	%>
	<tr>
		<td align='center' style="font-size : 8pt;"><%=i+1%></td>
		<td align='center' style="font-size : 8pt;"><%=car_no%></td>
		<td align='center' style="font-size : 8pt;"><%=ins_com_no%></td>
		<td align='center' style="font-size : 8pt;"><%=car_mng_id%></td>
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

