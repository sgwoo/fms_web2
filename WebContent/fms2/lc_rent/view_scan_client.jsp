<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*,acar.car_register.*,acar.client.*, acar.common.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	//스캔관리 페이지
	
	String client_id= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	//고객정보
	ClientBean client = al_db.getNewClient(client_id);
	
	Vector attach_vt = c_db.getAcarAttachFileLcScanClientList(client_id);		
	int attach_vt_size = attach_vt.size();	
	
	String rent_st = "";
	String file_st = "";
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>

<!--

//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post'>
<input type='hidden' name="client_id" value="<%=client_id%>">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>스캔관리</span></span> : 스캔관리</td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td class='title' width='15%'>상호</td>
                  <td>&nbsp;<%=client.getFirm_nm()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp; </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td class="title" width='5%'>연번</td>
                  <td class="title" width='10%'>계약일자</td>				  
                  <td class="title" width='15%'>계약번호</td>
                  <td class="title" width='30%'>구분</td>				  
                  <td class="title" width='25%'>파일보기</td>
                  <td class="title" width='15%'>등록일</td>
                </tr>
                <% 	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j); 
 					
 					if(!String.valueOf(ht.get("CONTENT_SEQ")).equals("") && String.valueOf(ht.get("CONTENT_SEQ")).length() > 20){
 						rent_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(19,20);
 						file_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(20); 						
 					}
 					
 					String td_color = "";
 					if(String.valueOf(ht.get("ISDELETED")).equals("Y")) td_color = "class='is'";
 		%>                    
                <tr>
                  <td align="center" <%=td_color%> ><%= j+1 %></td>
                  <td align="center" <%=td_color%> ><%= AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT"))) %></td>				  
                  <td align="center" <%=td_color%> ><%=ht.get("RENT_L_CD")%></td>				  
                  <td align="center" <%=td_color%> ><%=c_db.getNameByIdCode("0028", "", file_st)%></td>
                  <td align="center" <%=td_color%> ><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                  <td align="center" <%=td_color%> ><%=ht.get("REG_DATE")%>&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_USERSEQ")),"USER")%></td>
                </tr>
                <% 		}
    		  	}else{ %>
                <tr>
                  <td colspan="6" class=""><div align="center">해당 스캔파일이 없습니다.</div></td>
                </tr>
                <% 	} %>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp; </td>
    </tr>
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
