<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String est_id 	= request.getParameter("est_id")==null?"":request.getParameter("est_id");

	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String loc_st = request.getParameter("loc_st")==null?"":request.getParameter("loc_st");	
	String udt_st = "";
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	EstimateBean e_bean = new EstimateBean();
	
	if(!est_id.equals("")){
		e_bean = e_db.getEstimateCase(est_id);		
		car_comp_id = e_bean.getCar_comp_id();
		udt_st = e_bean.getUdt_st();
	}else{	
		if(loc_st.equals("1") || loc_st.equals("2") || loc_st.equals("3")){	
			udt_st = "1";
		}else if(loc_st.equals("7")){
			udt_st = "2";
		}else if(loc_st.equals("4")){
			udt_st = "3";
		}else if(loc_st.equals("6")){
			udt_st = "5";
		}else if(loc_st.equals("5")){
			udt_st = "6";
		}
	}	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//탁송업체 탁송료 조회
	function search()
	{
		var fm = document.form1;		
		if(fm.dlv_ext.value == '')		{ 	alert('출고지를 선택하십시오.'); 				return;	}
		if(fm.udt_st.value == '')		{	alert('인수지를 선택하십시오.'); 				return; }
		if(fm.off_id.value == '')		{	alert('탁송업체를 선택하십시오.'); 			return; }
		
		fm.action='/fms2/cons_cost/s_cons_cost.jsp';		
		fm.target='inner1';
		fm.submit();		
	}	
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post'>
<input type='hidden' name="car_comp_id" value="<%=car_comp_id%>">
<input type='hidden' name="mode" value="view">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>자체탁송료 조회</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>탁송의뢰</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>			
                <tr>                     
                    <td width=15% class=title>출고지</td>
                    <td width=35%>&nbsp;<select name='dlv_ext'>
                        <option value="">선택</option>     
                        <%if(car_comp_id.equals("0001")){%>
        				<option value='아산'>아산</option>
        				<option value='울산'>울산</option>        				
        				<%}else if(car_comp_id.equals("0002")){%>		
        				<option value='화성'>화성</option>        				
        				<option value='광주'>광주</option>
        				<%}else if(car_comp_id.equals("0003")){%>
        				<option value='부산'>부산</option>	
        				<%}%>
                      </select>
       			  </td>
                    <td width=15% class=title>탁송구분</td>                    
                    <td width=30%>&nbsp;<select name="cons_st" class='default'>
        				<option value="2">자체</option>							
        			  </select>
       			  </td>
    		    </tr>
                <tr>
                    <td class=title>인수지</td>
                    <td>&nbsp;<select name="udt_st">
                        <option value="">==선택==</option>
        				<option value="1" <%if(udt_st.equals("1"))%> selected<%%>>서울본사</option>
        				<option value="2" <%if(udt_st.equals("2"))%> selected<%%>>부산지점</option>
        				<option value="3" <%if(udt_st.equals("3"))%> selected<%%>>대전지점</option>				
        				<option value="5" <%if(udt_st.equals("5"))%> selected<%%>>대구지점</option>
        				<option value="6" <%if(udt_st.equals("6"))%> selected<%%>>광주지점</option>				        				
        			  </select>
        			</td>
                    <td class=title>업체명</td>
                    <td>&nbsp;<select name='off_id' class='default'>
                            <%if(car_comp_id.equals("0001")){%>
                            <option value='011372'> 상원물류 </option>                                
                            <%}else if(car_comp_id.equals("0002")){%>
                            <option value='007751'> 삼진특수 </option>	
                            <%}else if(car_comp_id.equals("0003")){%>	                                                    
                            <option value='010265'> 신화로직스 </option>
                            <option value='010266'> 대명운수 </option>
                            <%}%>
                        </select>
                        </td>
                </tr>                
    		</table>
	    </td>
	</tr> 
    <tr>
        <td class=h></td>
    </tr>
 
    <tr>
        <td align="right">	
		    <a href="javascript:search()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>&nbsp;		
			<a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr> 
    <tr>
        <td class=line2></td>
    </tr>    	
    <tr>
        <td class=h></td>
    </tr>    
	<tr>
	    <td>
		    <iframe src="/acar/menu/about_blank.jsp" name="inner1" width="100%" height="500" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
		    </iframe>
	    </td>
	</tr>  

</table>
</form>
<script language="JavaScript">
<!--		
//-->
</script>
</center> 
</body>
</html>
