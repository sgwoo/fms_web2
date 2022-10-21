<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	
	Vector vt = new Vector();
	
	vt = ec_db.getBusAnalysisStatList(s_kd, t_wd, s_dt, e_dt, gubun1, gubun2, gubun3);
	
	int cont_size = vt.size();
	
	int count =0;
	
%>

<html lang='ko'>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<script language='javascript'>
<!--

//-->
</script>
</head>
<body>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>		
        <td class='line' width='100%'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
    
                <%if(gubun3.equals("1")){%>
                <tr> 
                    <td width='3%' class='title'>연번</td>
                    <td width='9%' class='title'>계약번호</td>
                    <td width='7%' class='title'>계약일</td>
                    <td width="10%" class='title'>고객</td>
        	    <td width="15%" class='title'>차종</td>
        	    <td width="5%" class='title'>차량구분</td>
        	    <td width="5%" class='title'>계약구분</td>
        	    <td width="5%" class='title'>용도구분</td>
        	    <td width="5%" class='title'>관리구분</td>
       	            <td width='6%' class='title'>최초영업자</td>
        	    <td width='30%' class='title'>시장상황-계약이유</td>        	    
       		</tr>                
                <%}else{%>
                <tr> 
                    <td width='3%' class='title'>연번</td>
                    <td width='7%' class='title'>견적일자</td>
                    <td width='10%' class='title'>고객</td>
                    <td width="15%" class='title'>차종</td>
                    <td width="5%" class='title'>차량구분</td>
                    <td width='12%' class='title'>상품</td>
                    <td width="6%" class='title'>대여기간</td>        	
       	            <td width='7%' class='title'>견적담당자</td>
        	    <td width='35%' class='title'>시장상황-미계약이유</td>       	    
       		</tr>
                <%}%>
                
                <%if(cont_size > 0){%>
                <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				String td_color = "";
				if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = "class='is'";
				
				if(String.valueOf(ht.get("BUS_CAU")).equals("")) continue;
				
				count++;
		%>
				
		<%if(gubun3.equals("1")){%>		
                <tr> 
                    <td <%=td_color%> align='center'><%=count%></td>
                    <td <%=td_color%> align='center'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("USE_YN")%>')" onMouseOver="window.status=''; return true" title='계약상세내역'><%=ht.get("RENT_L_CD")%></a></td>
                    <td <%=td_color%> align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
                    <td <%=td_color%> align='center'><%=ht.get("FIRM_NM")%></td>
        	    <td <%=td_color%> align='center'><%=ht.get("CAR_NAME")%></td>        	    
        	    <td <%=td_color%> align='center'><%=ht.get("CAR_GU")%></td>
        	    <td <%=td_color%> align='center'><%=ht.get("RENT_ST")%></td>
        	    <td <%=td_color%> align='center'><%=ht.get("CAR_ST")%></td>
        	    <td <%=td_color%> align='center'><%=ht.get("RENT_WAY")%></td>
       		    <td <%=td_color%> align='center'><%=ht.get("USER_NM")%></td>
        	    <td <%=td_color%> align='left'>&nbsp;<%=ht.get("BUS_CAU")%></td>                    
                </tr>
                <%}else{%>
                <tr>                 
                    <td <%=td_color%> align='center'><%=count%></td>
                    <td <%=td_color%> align='center'><a href="javascript:parent.EstiDisp('<%=ht.get("EST_TYPE")%>','<%=ht.get("EST_ID")%>','<%=ht.get("SET_CODE")%>')" onMouseOver="window.status=''; return true" title='계약상세내역'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></a></td>                    
                    <td <%=td_color%> align='center'><%=ht.get("EST_NM")%></td>
                    <td <%=td_color%> align='center'><%=ht.get("CAR_NAME")%>></td>        	    
        	    <td <%=td_color%> align='center'><%=ht.get("CAR_GU")%></td>
        	    <td <%=td_color%> align='center'><%=ht.get("NM")%></td>
        	    <td <%=td_color%> align='center'><%=ht.get("A_B")%>개월</td>        	    
       		    <td <%=td_color%> align='center'><%=ht.get("USER_NM")%></td>
        	    <td <%=td_color%> align='left'>&nbsp;<%=ht.get("BUS_CAU")%></td>                
                </tr>
                <%}%>
                <%	}%>                
                <%}else{%>
                <tr> 
                    <td colspan='<%if(gubun3.equals("1")){%>11<%}else{%>9<%}%>' align='center'><%if(t_wd.equals("")){%>검색어를 입력하십시오.<%}else{%>등록된 데이타가 없습니다<%}%></td>
                </tr>
                <%}%>
            </table>
	</td>
    </tr>	
</table>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>

