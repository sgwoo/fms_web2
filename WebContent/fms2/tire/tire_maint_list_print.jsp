<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.tire.*" %>
<jsp:useBean id="t_db" scope="page" class="acar.tire.TireDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");	

	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String tire_gubun = request.getParameter("tire_gubun")==null?"":request.getParameter("tire_gubun");
	
	String title ="";
	if(tire_gubun.equals("000256")){
		title="타이어휠타운";
	}
	if(tire_gubun.equals("000148")){
		title="두꺼비카센타";
	}
	if(tire_gubun.equals("000156")){
		title="티스테이션시청점";
	}
	
	Vector vt = t_db.getDtireRegOffList(tire_gubun, s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt, "1");
	int vt_size = vt.size();
	
	long total_amt1	= 0;
		
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
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/smsx.cab#Version=6,3,439,30"></object><body onLoad="javascript:print()">
<form name='form1'  method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <table border="0" cellspacing="0" cellpadding="0" width='1070'>
  <tr>
		<td class='line' width='100%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>			
			<tr>
			  <td colspan="18" align="center"><%=title%> 차량정비 청구 리스트 </td>
			</tr>		
			
			 <tr> 
				<td width='4%' class='title'>연번</td>
				<td width='8%' class='title'>정비구분</td>
				<td width='7%' class='title'>정비일자</td>														  
				<td width='7%' class='title'>담당자</td>
				<td width='8%' class='title'>차량번호</td>
				<td width='10%' class='title'>차명</td>
				<td width='19%' class='title'>상호</td>					
				<td width='7%' class='title'>금액</td>
				<td width='23%' class='title'>내용</td>
			</tr>
			<%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>
			<tr>
			  <td  width='4%' align='center'><%=i+1%></td>
				<td  width='8%' align='center'><%=ht.get("GUBUN")%></td>
				<td  width='7%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DTIRE_DT")))%></td>					
				<td  width='7%' align='center'><%=ht.get("REQ_NM2")%></td>					
				<td  width='8%' align='center'><%=ht.get("DTIRE_CARNO")%></td>									
				<td  width='10%' align='center'>&nbsp;<%=ht.get("DTIRE_CARNM")%></td>
				<td  width='19%' align='center'>&nbsp;<%=ht.get("FIRM_NM")%></td>
				<td  width='7%' align='right'>&nbsp;<%=AddUtil.parseDecimal(ht.get("DTIRE_AMT"))%>&nbsp;</td>
				<td  width='23%'>&nbsp;
				<%if(!ht.get("DTIRE_ITEM1").equals("")){%><%=ht.get("DTIRE_ITEM1")%><%}%>
				<%if(!ht.get("DTIRE_ITEM2").equals("")){%><%if(!ht.get("DTIRE_ITEM1").equals("")){%>,&nbsp;<%}%><%=ht.get("DTIRE_ITEM2")%><%}%>
				<%if(!ht.get("DTIRE_ITEM3").equals("")){%><%if(!ht.get("DTIRE_ITEM1").equals("")&&!ht.get("DTIRE_ITEM2").equals("")){%>,&nbsp;<%}%>, <%=ht.get("DTIRE_ITEM3")%><%}%>
				<%if(!ht.get("DTIRE_ITEM4").equals("")){%><%if(!ht.get("DTIRE_ITEM1").equals("")&&!ht.get("DTIRE_ITEM2").equals("")&&!ht.get("DTIRE_ITEM3").equals("")){%>,&nbsp;<%}%>, <%=ht.get("DTIRE_ITEM4")%><%}%>
				<%if(!ht.get("DTIRE_ITEM5").equals("")){%><%if(!ht.get("DTIRE_ITEM1").equals("")&&!ht.get("DTIRE_ITEM2").equals("")&&!ht.get("DTIRE_ITEM3").equals("")&&!ht.get("DTIRE_ITEM4").equals("")){%>,&nbsp;<%}%>, <%=ht.get("DTIRE_ITEM5")%><%}%>
				<%if(!ht.get("DTIRE_ITEM6").equals("")){%><%if(!ht.get("DTIRE_ITEM1").equals("")&&!ht.get("DTIRE_ITEM2").equals("")&&!ht.get("DTIRE_ITEM3").equals("")&&!ht.get("DTIRE_ITEM4").equals("")&&!ht.get("DTIRE_ITEM5").equals("")){%>,&nbsp;<%}%>, <%=ht.get("DTIRE_ITEM6")%><%}%>
				</td>
			</tr>
			<%		total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("DTIRE_AMT")));
					
				}%>
			
			<tr>				  				  
				<td align='center' colspan=3 class='title'>합계</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>			 
				<td class="title" colspan=2 style='text-align:right'><%=Util.parseDecimal(total_amt1)%> 원&nbsp;</td>					
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
factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin = 5.0; //좌측여백   
factory.printing.topMargin = 5.0; //상단여백    
factory.printing.rightMargin = 5.0; //우측여백
factory.printing.bottomMargin = 5.0; //하단여백
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
</script>

