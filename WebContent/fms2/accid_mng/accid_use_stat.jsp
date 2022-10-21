<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	//@ author : JHM - 담담자별사고미종결현황
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"0":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	
	Vector vt = as_db.getAccidSettleStat("1");
	int vt_size = vt.size();
	
	int total_su 	= 0;
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function Search(t_wd){
		var fm = document.form1;
		fm.s_st.value = '3';
		fm.gubun3.value = '0';
		fm.s_kd.value = '8';
		fm.t_wd.value = t_wd;		
		fm.action="/acar/accid_mng/accid_s_frame.jsp";
		fm.target="d_content";		
		fm.submit();
	}
//-->
</script>
<style type=text/css>

<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin=15>

<form name='form1' action='accid_u_frame.jsp' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='go_url' value='/fms2/accid_mng/accid_use_stat.jsp'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='accid_id' value=''>
<input type='hidden' name='accid_st' value=''>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='idx' value='<%=idx%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고관리 > <span class=style5>담당자별사고미종결현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
	    <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>1군</td>
    </tr>    
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=5% class=title>연번</td>
                    <td width=10% class=title>근무지</td>
                    <td width=10% class=title>부서</td>
                    <td width=15% class=title>이름</td>                                        
                    <td width=15% class=title>미결</td>
                    <td width=15% class=title>종결</td>
                    <td width=15% class=title>합계</td>
                    <td width=15% class=title>종결율</td>
                </tr>
                <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					total_su 	= total_su + AddUtil.parseInt(String.valueOf(ht.get("N_CNT")));
                %>	            
                <tr> 
                    <td align='center'><%=i+1%></td>                    
                    <td align='center'><%=ht.get("BR_NM")%></td>
                    <td align='center'><%=ht.get("DEPT_NM")%></td>
                    <td align='center'><a href="javascript:Search('<%=ht.get("MNG_ID")%>')" onMouseOver="window.status=''; return true" title='사고리스트 보기'><%=ht.get("USER_NM")%></a></td>                    
                    <td align='center'><font color=red><%=ht.get("N_CNT")%></font></td>
                    <td align='center'><%=ht.get("Y_CNT")%></td>
                    <td align='center'><%=ht.get("T_CNT")%></td>
                    <td align='center'><%=ht.get("Y_PER")%>%</td>
                </tr>    				                                    				
		<%	}%> 
		<tr>
		    <td class=title colspan='4'>합계</td>
		    <td align='center'><%=total_su%></td>
		    <td colspan='3'>&nbsp;</td>
		</tr>               																																	
            </table>
        </td>
    </tr>    
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>2군</td>
    </tr>    
    <%
    	vt = as_db.getAccidSettleStat("2");
	vt_size = vt.size();
	total_su 	= 0;
    %>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=5% class=title>연번</td>
                    <td width=10% class=title>근무지</td>
                    <td width=10% class=title>부서</td>
                    <td width=15% class=title>이름</td>                                        
                    <td width=15% class=title>미결</td>
                    <td width=15% class=title>종결</td>
                    <td width=15% class=title>합계</td>
                    <td width=15% class=title>종결율</td>
                </tr>
                <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					total_su 	= total_su + AddUtil.parseInt(String.valueOf(ht.get("N_CNT")));
                %>	            
                <tr> 
                    <td align='center'><%=i+1%></td>                    
                    <td align='center'><%=ht.get("BR_NM")%></td>
                    <td align='center'><%=ht.get("DEPT_NM")%></td>
                    <td align='center'><a href="javascript:Search('<%=ht.get("MNG_ID")%>')" onMouseOver="window.status=''; return true" title='사고리스트 보기'><%=ht.get("USER_NM")%></a></td>                    
                    <td align='center'><font color=red><%=ht.get("N_CNT")%></font></td>
                    <td align='center'><%=ht.get("Y_CNT")%></td>
                    <td align='center'><%=ht.get("T_CNT")%></td>
                    <td align='center'><%=ht.get("Y_PER")%>%</td>
                </tr>    				                                    				
		<%	}%>    
		<tr>
		    <td class=title colspan='4'>합계</td>
		    <td align='center'><%=total_su%></td>
		    <td colspan='3'>&nbsp;</td>
		</tr>       		            																																	
            </table>
        </td>
    </tr>  

</table>
</form>
</body>
</html>
