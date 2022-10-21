<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.con_tax.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
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
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"13":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");
	
	
	
	Vector taxs = t_db.getTaxScdList(br_id, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int tax_size = taxs.size();
%>
<form name='form1' action='tax_pay_sc.jsp' method="post">
<input type='hidden' name='tax_size' value='<%=tax_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
  	<tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='55%' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width=7% class='title' style='height:36'>연번</td>
                    <td width=7% class='title'>구분</td>
        			<td width=10% class='title'>등록여부</td>			
                    <td width=20% class='title'>계약번호</td>
                    <td width=20% class='title'>상호</td>
                    <td width=18% class='title'>차량번호</td>
                    <td class='title' width=18%>차명</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='45%'>
		    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>					
                    <td width=17% class='title' style='height:36'>출고일</td>
                    <td width=17% class='title'>신차<br>대여개시일</td>					
                    <td width=15% class='title'>해지일자</td>					
                    <td width=16% class='title'>명의이전일</td>											
                    <td width=15% class='title'>배기량</td>
        			<td width=20% class='title'>면세구입가</td>
		        </tr>
		    </table>
	    </td>
	</tr>
<%	if(tax_size > 0){%>
	<tr>
	    <td class='line' width='55%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < tax_size ; i++){
				Hashtable tax = (Hashtable)taxs.elementAt(i);
				String use_yn = (String)tax.get("USE_YN");%>
                <tr> 
                    <td <%if(use_yn.equals("N"))%>class='is'<%%> align='center' width=7%><%=i+1%></td>
                    <td <%if(use_yn.equals("N"))%>class='is'<%%> align='center' width=7%> 
                      <%if(use_yn.equals("Y")){%>
                      대여 
                      <%}else{%>
                      해지 
                      <%}%>
                    </td>
                    <td <%if(use_yn.equals("N"))%>class='is'<%%> align='center' width=10%><%=tax.get("REG_YN")%></td>								
                    <td <%if(use_yn.equals("N"))%>class='is'<%%> align='center' width=20%> 
                      <%if(tax.get("REG_YN").equals("Y")){%>
                      <a href="javascript:parent.view_scd_tax('<%=tax.get("RENT_MNG_ID")%>', '<%=tax.get("RENT_L_CD")%>', '<%=tax.get("CAR_MNG_ID")%>', '<%=tax.get("SEQ")%>', '<%=tax.get("CLS_ST")%>', 'u', '')" onMouseOver="window.status=''; return true"><%=tax.get("RENT_L_CD")%></a> 
                      <%}else{%>
                      <a href="javascript:parent.view_scd_tax('<%=tax.get("RENT_MNG_ID")%>', '<%=tax.get("RENT_L_CD")%>', '<%=tax.get("CAR_MNG_ID")%>', '<%=tax.get("SEQ")%>', '<%=tax.get("CLS_ST")%>', 'i', '<%=tax.get("RENT_MON")%>')" onMouseOver="window.status=''; return true"><%=tax.get("RENT_L_CD")%></a> 
                      <%}%>
                    </td>
                    <td <%if(use_yn.equals("N"))%>class='is'<%%> align='center' width=20%>&nbsp;<span title='<%=tax.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(tax.get("FIRM_NM")), 6)%></span></td>
                    <td <%if(use_yn.equals("N"))%>class='is'<%%> align='center' width=18%><a href="javascript:parent.view_car_tax('<%=tax.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"><%=tax.get("CAR_NO")%></a></td>
                    <td <%if(use_yn.equals("N"))%>class='is'<%%> align='center' width=18%><span title='<%=tax.get("CAR_NM")+" "+tax.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(tax.get("CAR_NM"))+" "+String.valueOf(tax.get("CAR_NAME")), 5)%></span> 
                    </td>
                </tr>
                <%}%>
            </table>
        </td>
		<td class='line' width='45%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < tax_size ; i++){
				Hashtable tax = (Hashtable)taxs.elementAt(i);
				String use_yn = (String)tax.get("USE_YN");%>
                <tr>
        			<td <%if(use_yn.equals("N"))%>class='is'<%%> align='center' width=17%><%=tax.get("DLV_DT")%></td>					
                    <td <%if(use_yn.equals("N"))%>class='is'<%%> align='center' width=17%><%=AddUtil.ChangeDate2(String.valueOf(tax.get("RENT_START_DT2")))%></td>					
                    <td <%if(use_yn.equals("N"))%>class='is'<%%> align='center' width=15%><%=tax.get("CLS_DT")%></td>					
                    <td <%if(use_yn.equals("N"))%>class='is'<%%> align='center' width=16%><%=tax.get("CONT_DT")%></td>											
                    <td <%if(use_yn.equals("N"))%>class='is'<%%> align='center' width=15%><%=tax.get("DPM")%>CC</td>					
                    <td <%if(use_yn.equals("N"))%>class='is'<%%> align='right' width=20%><%=Util.parseDecimal(String.valueOf(tax.get("CAR_FS_AMT")))%>원&nbsp;</td>					
		        </tr>
<%		}%>
		    </table>
	    </td>
	</tr>		
<%	}else{%>
	<tr>
	    <td class='line' width='55%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
			        <td align='center'>등록된 데이타가 없습니다</td>
		        </tr>
		    </table>
	    </td>
	    <td class='line' width='45%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
			        <td>&nbsp;</td>
		        </tr>
		    </table>
	    </td>
	</tr>
<%	}%>
</table>
</form>
</body>
</html>
