<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.master_car.*" %>
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");	

	String s_kd 	= request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
					
	Vector vt = mc_db.getSsmotersComAcarExcelList1(gubun3, gubun2, s_kd, st_dt, end_dt, "2", gubun4);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	
	String gubun4_nm = "";
	
	 if ( gubun4.equals("011614")) {
    	  gubun4_nm = "차비서";
	 } else  if ( gubun4.equals("008462")) {
        	  gubun4_nm = "성서현대";	  
    } else {
    	 gubun4_nm = "성수자동차";   
    }
		
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<!-- MeadCo ScriptX -->
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30"></object><body onLoad="javascript:print()">
<form name='form1'  method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <table border="0" cellspacing="0" cellpadding="0" width='1070'>
  <tr>
		<td class='line' width='100%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>			
			<tr>
			  <td colspan="18" align="center">(주)아마존카 자동차 검사 청구 리스트   </td>
			</tr>		
			<tr>
			  <td colspan="18" align="center">업체 : <%=gubun4%>  </td>
			</tr>
			
			 <tr> 
			       	<td style="font-size:8pt"  >연번</td>			
					<td style="font-size:8pt"  >청구일자</td>	  	  
					<td style="font-size:8pt"  >차량번호</td>
					<td style="font-size:8pt"  >차종</td>
				    <td style="font-size:8pt"  >연식</td>				
					<td style="font-size:8pt"  >고객</td>
					<td style="font-size:8pt"  >검사일자</td>		
					<td style="font-size:8pt"  >검사소</td>
					<td style="font-size:8pt"  >검사종류</td>
					<td style="font-size:8pt"  >검사금액</td>	
					<td style="font-size:8pt"  >주행거리</td>
					<td style="font-size:8pt"  >등록지역</td>
					<td style="font-size:8pt"  >관리<br>담당자</td>			
						  	  	  	  
			</tr>
			<%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>
			<tr>
			  <td style="font-size:8pt" align="center" ><%=i+1%></td>         
			  <td style="font-size:8pt" align="center" ><%=ht.get("청구일")%></td>	  	  
			  <td style="font-size:8pt" align="center"><%=ht.get("차량번호")%></td>
			  <td style="font-size:8pt" align="center"><%=ht.get("차종")%></td>	 
			  <td style="font-size:8pt" align="center"><%=ht.get("연식")%></td>				 
			  <td style="font-size:8pt" align="center"><%=ht.get("고객")%></td>
			  <td style="font-size:8pt" align="center"><%=ht.get("검사일")%></td>	  	  
			  <td style="font-size:8pt" align="center"><%=ht.get("검사소")%></td>
			  <td style="font-size:8pt" align="center"><%=ht.get("종류")%></td>		
			  <td style="font-size:8pt" align="right" ><%=AddUtil.parseDecimal(ht.get("검사금액"))%></td>	
			  <td style="font-size:8pt" align="right" ><%=AddUtil.parseDecimal(ht.get("주행거리"))%></td>	
			  <td style="font-size:8pt" align="center"><%=ht.get("등록지역")%></td>	 			
			  <td style="font-size:8pt" align="center"><%=ht.get("관리담당자")%></td>  
			</tr>
			<%		total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("검사금액")));
					
				}%>
			
			<tr>				  				  
			  <td align='center' colspan=3 >합계</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>			 
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td style="font-size:8pt"  colspan=2 align='right'><%=Util.parseDecimal(total_amt1)%></td>					
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>	 
			  <td>&nbsp;</td>
			  			  
			</tr>	
		</table>
	 </td>					

 </tr>
 </table>
</form>
</body>
</html>

<script>
onprint();

function onprint(){
factory.printing.header = ""; //폐이지상단 인쇄
factory.printing.footer = ""; //폐이지하단 인쇄
factory.printing.portrait = false; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin = 5.0; //좌측여백   
factory.printing.topMargin = 5.0; //상단여백    
factory.printing.rightMargin = 5.0; //우측여백
factory.printing.bottomMargin = 5.0; //하단여백
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
</script>

