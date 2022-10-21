<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");

	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "07", "04", "04");
	
		
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	
	
	Vector vt = umd.getPurComBusList();
	int vt_size = vt.size();
		
	
	int total_su1 	= 0;
	int total_su2 	= 0;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function Search(st, t_wd){
		var fm = document.form1;
		var url = "";
		//예정
		if(st == '1'){
			url = '/fms2/pur_com/pur_est_frame.jsp';
			fm.gubun1.value = '2';
			fm.gubun2.value = '4';
			fm.gubun3.value = '';
			fm.sort.value   = '2';
		//확정
		}else if(st == '2'){
			url = '/fms2/pur_com/pur_con_frame.jsp';		
			fm.gubun1.value = '2';
			fm.gubun2.value = '4';
			fm.gubun3.value = '';
			fm.sort.value   = '2';
		//변경반영
		}else if(st == '3'){
			url = '/fms2/pur_com/pur_cng_frame.jsp';		
			fm.gubun1.value = '2';
			fm.gubun2.value = '4';
			fm.gubun3.value = '2';
			fm.sort.value   = '2';
		//변경미반영
		}else if(st == '4'){
			url = '/fms2/pur_com/pur_cng_frame.jsp';		
			fm.gubun1.value = '1';
			fm.gubun2.value = '4';
			fm.gubun3.value = '1';
			fm.sort.value   = '1';
		//해지반영
		}else if(st == '5'){
			url = '/fms2/pur_com/pur_cls_frame.jsp';		
			fm.gubun1.value = '2';
			fm.gubun2.value = '4';
			fm.gubun3.value = '';
			fm.sort.value   = '2';
		//해지미반영
		}else if(st == '6'){
			url = '/fms2/pur_com/pur_cng_frame.jsp';		
			fm.gubun1.value = '1';
			fm.gubun2.value = '4';
			fm.gubun3.value = '1';
			fm.sort.value   = '1';
		}
		fm.s_kd.value 	= '4';
		fm.t_wd.value 	= t_wd;		
		fm.action = url;
		fm.target='d_content';
		fm.submit();
	}
	
//-->
</script>
</head>
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='sort'	value='<%=sort%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>  
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/pur_com/pur_bus_frame.jsp'> 
  
<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>계출관리 > <span class=style5>영업담당자별현황</span></span></td>
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
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=5% rowspan="2" class=title>연번</td>
                    <td width=10% rowspan="2" class=title>근무지</td>
                    <td width=10% rowspan="2" class=title>부서</td>
                    <td width=15% rowspan="2" class=title>이름</td>                                        
                    <td width=10% rowspan="2" class=title>출고예정</td>
                    <td width=10% rowspan="2" class=title>출고배정</td>
                    <td colspan="2" class=title>계약변경</td>
                    <td colspan="2" class=title>계약해지</td>
                </tr>
                <tr>
                  <td width=10% class=title>반영</td>
                  <td width=10% class=title>미반영</td>
                  <td width=10% class=title>반영</td>
                  <td width=10% class=title>미반영</td>
                </tr>
                <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					total_su1 	= total_su1 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST1_CNT")));
					total_su2 	= total_su2 + AddUtil.parseInt(String.valueOf(ht.get("DLV_ST2_CNT")));
                %>	            
                <tr> 
                    <td align='center'><%=i+1%></td>                    
                    <td align='center'><%=ht.get("BR_NM")%></td>
                    <td align='center'><%=ht.get("DEPT_NM")%></td>
                    <td align='center'><%=ht.get("USER_NM")%></td>                    
                    <td align='center'><a href="javascript:Search('1','<%=ht.get("USER_NM")%>')" onMouseOver="window.status=''; return true" title='출고예정 보기'><%=ht.get("DLV_ST1_CNT")%></a></td>
                    <td align='center'><a href="javascript:Search('2','<%=ht.get("USER_NM")%>')" onMouseOver="window.status=''; return true" title='출고확정 보기'><%=ht.get("DLV_ST2_CNT")%></a></td>
                    <td align='center'><a href="javascript:Search('3','<%=ht.get("USER_NM")%>')" onMouseOver="window.status=''; return true" title='계약변경반영 보기'><%=ht.get("CNG_APP_CNT")%></a></td>
                    <td align='center'><a href="javascript:Search('4','<%=ht.get("USER_NM")%>')" onMouseOver="window.status=''; return true" title='계약변경미반영 보기'><%=ht.get("CNG_REG_CNT")%></a></td>
                    <td align='center'><a href="javascript:Search('5','<%=ht.get("USER_NM")%>')" onMouseOver="window.status=''; return true" title='계약해지반영 보기'><%=ht.get("CLS_APP_CNT")%></a></td>
                    <td align='center'><a href="javascript:Search('6','<%=ht.get("USER_NM")%>')" onMouseOver="window.status=''; return true" title='계약해지미반영 보기'><%=ht.get("CLS_REG_CNT")%></a></td>
                </tr>    				                                    				
		<%	}%> 
		<tr>
		    <td class=title colspan='4'>합계</td>
		    <td align='center'><%=total_su1%></td>
		    <td align='center'><%=total_su2%></td>
		    <td>&nbsp;</td>
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

