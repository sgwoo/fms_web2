<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*, acar.cus0601.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String car_comp_id	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String car_cd 		= request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String off_id 		= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String off_nm 		= request.getParameter("off_nm")==null?"":request.getParameter("off_nm");
	String dlv_ext 		= request.getParameter("dlv_ext")==null?"":request.getParameter("dlv_ext");
	String udt_st 		= request.getParameter("udt_st")==null?"":request.getParameter("udt_st");
	String go_url 		= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String idx 			= request.getParameter("idx")==null?"":request.getParameter("idx");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	if(!off_id.equals("") && off_nm.equals("")){
		Cus0601_Database c61_db = Cus0601_Database.getInstance();
		c61_soBn = c61_db.getServOff(off_id);
		off_nm = c61_soBn.getOff_nm();
	}
	
	
	Vector vt = cs_db.getConsCostSearchList(off_id, car_comp_id, car_cd, dlv_ext, udt_st);
	int vt_size = vt.size();

%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
//		var fm = document.form1;	
//		if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }	
//		fm.submit();
	}
	function enter() {
//		var keyValue = event.keyCode;
//		if (keyValue =='13') search();
	}
	
	function Disp1(cons_cost){
		var fm = document.form1;
		<%if(car_comp_id.equals("0000")){%>
			opener.form1.cons_amt[<%=idx%>].value 	= parseDecimal(cons_cost);
			opener.set_amt();
		<%}else{%>
		opener.form1.cons_amt1.value 	= parseDecimal(cons_cost);
		opener.set_cons_amt();
		<%}%>		
		self.close();
	}

//-->
</script>
</head>

<body>
<form name='form1' method='post'>
 <input type='hidden' name='go_url' value='<%=go_url%>'> 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <%if(!mode.equals("view")){%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>탁송요금</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
	    <td class=line2></td>
	</tr>	   
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>탁송업체</td>
                    <td width=15%>&nbsp;<%=off_nm%></td>
                    <td class=title width=10%>제조사</td>
                    <td width=15%>&nbsp;<%=c_db.getNameById(car_comp_id,"CAR_COM")%></td>
                    <td class=title width=10%>차종</td>
                    <td width=40%>&nbsp;<%=c_db.getNameById(car_comp_id+car_cd,"CAR_MNG")%></td>
    		    </tr>
                <tr> 
                    <td class=title width=10%>출고지</td>
                    <td width=15%>&nbsp;<%=dlv_ext%></td>
                    <td class=title width=10%>인수지</td>
                    <td colspan='3'>&nbsp;<%if(udt_st.equals("1")){%>서울본사<%}else if(udt_st.equals("2")){%>부산지점<%}else if(udt_st.equals("3")){%>대전지점<%}else if(udt_st.equals("5")){%>대구지점<%}else if(udt_st.equals("6")){%>광주지점<%}else{%><%=udt_st%><%}%></td>
    		    </tr>
    		</table>
	    </td>
	</tr> 
	<tr>
	    <td align="right">&nbsp;</td>
	</tr> 
	<%} %>
	<tr>
	    <td class=line2></td>
	</tr>				
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="10%">기준일자</td>
                    <td class=title width="25%">차명</td>
                    <td class=title width="15%">출하장</td>			
                    <td class=title width="10%">서울본사</td>
                    <td class=title width="10%">부산지점</td>			
                    <td class=title width="10%">대전지점</td>						
                    <td class=title width="10%">대구지점</td>			
                    <td class=title width="10%">광주지점</td>						
                </tr>
            <%for (int i = 0 ; i < vt_size ; i++){
  				Hashtable ht = (Hashtable)vt.elementAt(i);
  				
    				
    	    %>
                <tr align="center">
                    <td><%=ht.get("COST_B_DT")%></td>
                    <td><%=ht.get("CAR_NM")%></td>
                    <td><%=ht.get("FROM_PLACE")%></td>
                    <td><%if(!mode.equals("view") && (udt_st.equals("1") || (!udt_st.equals("1") && !udt_st.equals("2") && !udt_st.equals("3") && !udt_st.equals("4") && !udt_st.equals("5") && !udt_st.equals("6")))){%><a href="javascript:Disp1(<%=ht.get("TO_PLACE1")%>)" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimal(ht.get("TO_PLACE1"))%></a><%}else{%><%=AddUtil.parseDecimal(ht.get("TO_PLACE1"))%><%}%></td>
                    <td><%if(!mode.equals("view") && (udt_st.equals("2") || (!udt_st.equals("1") && !udt_st.equals("2") && !udt_st.equals("3") && !udt_st.equals("4") && !udt_st.equals("5") && !udt_st.equals("6")))){%><a href="javascript:Disp1(<%=ht.get("TO_PLACE2")%>)" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimal(ht.get("TO_PLACE2"))%></a><%}else{%><%=AddUtil.parseDecimal(ht.get("TO_PLACE2"))%><%}%></td>
                    <td><%if(!mode.equals("view") && (udt_st.equals("3") || (!udt_st.equals("1") && !udt_st.equals("2") && !udt_st.equals("3") && !udt_st.equals("4") && !udt_st.equals("5") && !udt_st.equals("6")))){%><a href="javascript:Disp1(<%=ht.get("TO_PLACE3")%>)" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimal(ht.get("TO_PLACE3"))%></a><%}else{%><%=AddUtil.parseDecimal(ht.get("TO_PLACE3"))%><%}%></td>		  
                    <td><%if(!mode.equals("view") && (udt_st.equals("5") || (!udt_st.equals("1") && !udt_st.equals("2") && !udt_st.equals("3") && !udt_st.equals("4") && !udt_st.equals("5") && !udt_st.equals("6")))){%><a href="javascript:Disp1(<%=ht.get("TO_PLACE4")%>)" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimal(ht.get("TO_PLACE4"))%></a><%}else{%><%=AddUtil.parseDecimal(ht.get("TO_PLACE4"))%><%}%></td>
                    <td><%if(!mode.equals("view") && (udt_st.equals("6") || (!udt_st.equals("1") && !udt_st.equals("2") && !udt_st.equals("3") && !udt_st.equals("4") && !udt_st.equals("5") && !udt_st.equals("6")))){%><a href="javascript:Disp1(<%=ht.get("TO_PLACE5")%>)" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimal(ht.get("TO_PLACE5"))%></a><%}else{%><%=AddUtil.parseDecimal(ht.get("TO_PLACE5"))%><%}%></td>		  
                </tr>
            <%		}%>
            </table>
	    </td>
    </tr>	
    <%if(!mode.equals("view")){%>
    <tr> 
        <td align="center">
	    <a href="javascript:window.close();"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>		
	    </td>
    </tr>
    <%}%>
</table>
</form>
</body>
</html>