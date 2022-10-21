<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.user_mng.*,acar.common.*,acar.car_office.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" 	class="acar.fee.AddFeeDatabase"			   scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	LoginBean login = LoginBean.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();

	//영업수당 스캔관리 페이지
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String rent_st 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String file_st  = request.getParameter("file_st")==null?"":request.getParameter("file_st");	

	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	String content_code = "COMMI";
	String content_seq  = m_id+""+l_cd;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();	
	
	//영업수당+영업소 담당자
	CommiBean emp1 	= a_db.getCommi(m_id, l_cd, "1");
	
	String content_code2 = "CAR_OFF_EMP";
	String content_seq2  = emp1.getEmp_id();

	Vector attach_vt2 = c_db.getAcarAttachFileList(content_code2, content_seq2, 0);		
	int attach_vt_size2 = attach_vt2.size();	
	
	//영업사원
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp1.getEmp_id());
	
	//에이전트관리 20131101
	CarOffBean a_co_bean = new CarOffBean();
	if(!coe_bean.getAgent_id().equals("")){
		a_co_bean = cod.getCarOffBean(coe_bean.getAgent_id());
	}else{
		a_co_bean = cod.getCarOffBean(coe_bean.getCar_off_id());
	}
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
<form name='form1' action='scan_view_a.jsp' method='post' enctype="multipart/form-data">
<input type='hidden' name="m_id" value="<%=m_id%>">
<input type='hidden' name="l_cd" value="<%=l_cd%>">
<table border="0" cellspacing="0" cellpadding="0" width=670>
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
        <td class=h></td>
    </tr>
	      <%	Hashtable est = a_db.getRentEst(m_id, l_cd);%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td class='title' width='14%'>계약번호</td>
                  <td width='20%'>&nbsp;<%=l_cd%></td>
                  <td class='title' width='14%'>상호</td>
                  <td>&nbsp;<%=est.get("FIRM_NM")%></td>
                </tr>
                <tr> 
                  <td class='title'>차량번호</td>
                  <td>&nbsp;<%=est.get("CAR_NO")%></td>
                  <td class='title'>차명</td>
                  <td>&nbsp;<%=est.get("CAR_NM")%> <%=est.get("CAR_NAME")%></td>
                </tr>	
                <tr> 
                  <td class='title'>신고구분</td>
                  <td colspan='3'>&nbsp;<%if(a_co_bean.getDoc_st().equals("2")){ //에이전트-세금계산서 발행분%>세금계산서 발행분<%}else{ %>근로소득 신고분<%} %></td>
                </tr>
                	
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>스캔파일</span></td>
    </tr>		
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width='10%'>연번</td>
                    <td class="title" width='15%'>수당구분</td>
                    <td class="title" width='15%'>파일구분</td>                    
                    <td class="title" width='30%'>파일보기</td>
                    <td class="title" width='30%'>등록일</td>
                </tr>                
                <% 	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j); 
 					
 					if(!String.valueOf(ht.get("CONTENT_SEQ")).equals("") && String.valueOf(ht.get("CONTENT_SEQ")).length() > 20){
 						rent_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(19,20);
 						file_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(20); 						
 					}
 				%>                
                <tr>
                    <td align="center"><%= j+1 %></td>
                    <td align="center"><%if(rent_st.equals("1")){%>영업수당<%}else if(rent_st.equals("4")){ %>대리영업<%}%></td>					
                    <td align="center"><%if(file_st.equals("1")){%>신분증사본<%}else if(file_st.equals("2")){ %>통장사본<%}%></td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%>&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_USERSEQ")),"USER")%></td>
                </tr>
                <% 		}
    		  		} %>
                
   		  	   	<% 	if(attach_vt_size == 0){ %>
	    		  	 <tr>
	                  <td colspan="5" class=""><div align="center">해당 스캔파일이 없습니다.</div></td>
	                </tr>	
   		  		<%}%>
            </table>
        </td>
    </tr>
    <% 	if(attach_vt_size < 2 && attach_vt_size2 > 0){%>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>영업사원 파일</span></td>
    </tr>		
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width='10%'>연번</td>
                    <td class="title" width='15%'>성명</td>
                    <td class="title" width='15%'>파일구분</td>                    
                    <td class="title" width='30%'>파일보기</td>
                    <td class="title" width='30%'>등록일</td>
                </tr>                
                <% 	for (int j = 0 ; j < attach_vt_size2 ; j++){
 						Hashtable ht = (Hashtable)attach_vt2.elementAt(j); 
 					
	 					if(!String.valueOf(ht.get("CONTENT_SEQ")).equals("") && String.valueOf(ht.get("CONTENT_SEQ")).length() > 5){
 							file_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(6); 						
 						}
 				%>                
                <tr>
                    <td align="center"><%= j+1 %></td>
                    <td align="center"><%=emp1.getEmp_nm()%></td>					
                    <td align="center"><%if(file_st.equals("1")){%>신분증사본<%}else if(file_st.equals("2")){ %>통장사본<%}%></td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%>&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_USERSEQ")),"USER")%></td>
                </tr>
                <% 	}%>                   		  	  
            </table>
        </td>
    </tr>    
    <%	} %>
    <tr>
        <td align="right">            
            <a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>  
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
