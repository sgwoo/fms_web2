<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.commi_mng.*, acar.car_office.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	function init(){		
		setupEvents();
	}	
-->
</script>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String emp_id = request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
	int total_su = 0;
	long total_amt = 0;
	
	String f_list = request.getParameter("f_list")==null?"now":request.getParameter("f_list");
	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	Vector commis = cod.getCommiList(emp_id);
	int commi_size = commis.size();
%>
<table border="0" cellspacing="0" cellpadding="0" width='900'>
	<tr id='tr_title' style='position:relative;z-index:1'>
		
    <td class='line' width='500' id='td_title' style='position:relative;'> <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr> 
          <td width='70' class='title'>연번</td>
          <td width='95' class='title'>계약번호</td>
          <td width='125' class='title'>상호</td>
          <td width='90' class='title'>차량번호</td>
          <td width='120' class='title'>차명</td>
        </tr>
      </table></td>
		<td class='line' width='400'>
			<table border="0" cellspacing="1" cellpadding="0" width='400'>
        <tr> 
          <td width='80' class='title'>출고일자</td>
          <td width='80' class='title'>지급수수료</td>
          <td width='80' class='title'>세금</td>
          <td width='80' class='title'>차인지급액</td>
          <td width='80' class='title'>지급일자</td>
        </tr>
      </table>
		</td>
	</tr>
<%	if(commi_size > 0){%>
	<tr>
		
    <td class='line' width='500' id='td_con' style='position:relative;'> <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%		for(int i = 0 ; i < commi_size ; i++){
				Hashtable commi = (Hashtable)commis.elementAt(i);%>
        <tr> 
          <td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='70'><%=i+1%> <%if(commi.get("USE_YN").equals("N")) out.println("(해지)");%></td>
          <td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='95'><a href="javascript:parent.view_commi('<%=commi.get("RENT_MNG_ID")%>', '<%=commi.get("RENT_L_CD")%>', '<%=commi.get("CAR_MNG_ID")%>', '<%=commi.get("EMP_ID")%>')" onMouseOver="window.status=''; return true"><%=commi.get("RENT_L_CD")%></a></td>
          <td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='left'   width='125'>&nbsp;<span title='<%=commi.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(commi.get("FIRM_NM")), 8)%></span></td>
          <td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='90'><%=commi.get("CAR_NO")%></td>
          <td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='120'><span title='<%=commi.get("CAR_NM")%> <%=commi.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(commi.get("CAR_NM"))+" "+String.valueOf(commi.get("CAR_NAME")), 9)%></span></td>
        </tr>
        <%			total_su = total_su + 1;	
			total_amt = total_amt  + Long.parseLong(String.valueOf(commi.get("COMMI")));
		}%>
        <tr> 
          <td width='70' class='title'>합계</td>
          <td width='95' class='title'>건수</td>
          <td width='125' class='title'><%=total_su%>건</td>
          <td width='90' class='title'>금액</td>
          <td width='120' class='title'><%=Util.parseDecimal(total_amt)%>원</td>
        </tr>
      </table></td>
		<td class='line' width='400'>
			
      <table border="0" cellspacing="1" cellpadding="0" width='400'>
        <%		for(int i = 0 ; i < commi_size ; i++){
				Hashtable commi = (Hashtable)commis.elementAt(i);%>
        <tr> 
          <td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='80'><%=commi.get("DLV_DT")%></td>
          <td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='right' width='80'><%=Util.parseDecimal(String.valueOf(commi.get("COMMI")))%>원&nbsp;</td>
          <td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='right' width='80'><%=Util.parseDecimal(String.valueOf(commi.get("COMMI_FEE")))%>원&nbsp;</td>
          <td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='right' width='80'><%=Util.parseDecimal(String.valueOf(commi.get("DIF_AMT")))%>원&nbsp;</td>
          <td <%if(commi.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'  width='80'><%=commi.get("SUP_DT")%></td>
        </tr>
        <%		}%>
        <tr> 
          <td colspan="5" class='title'>&nbsp;</td>
        </tr>
      </table>
		</td>
	</tr>
<%	}else{%>                     
	<tr>
		
    <td class='line' width='500' id='td_con' style='position:relative;'> <table border="0" cellspacing="1" cellpadding="0" width="100%">
        <tr> 
          <td align='center'>등록된 데이타가 없습니다</td>
        </tr>
      </table></td>
		<td class='line' width='400'>
			<table border="0" cellspacing="1" cellpadding="0" width='400'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%	}%>
</table>
</body>
</html>