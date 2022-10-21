<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*,acar.user_mng.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String white = "";
	String disabled = "";
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	if(nm_db.getWorkAuthUser("아마존카이외",user_id)){
		white = "white";
		disabled = "disabled";
	}
	
	Vector branches = c_db.getUserBranchs("rent"); 			//영업소 리스트
	int brch_size 	= branches.size();
	
		
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function search()
	{
		document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body <%if(white.equals("")){%>onload="javascript:document.form1.t_wd.focus();"<%}%> leftmargin=15>
<form name='form1' action='/fms2/consignment_new/cons_req_sc2.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>

  
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>협력업체 > 탁송관리 > <span class=style5>결재완료현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>조건검색</span></td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td colspan="2" class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=10%>청구일자</td>
                    <td width=40%>&nbsp;
            		    <select name='gubun1'>
                          <option value='3' <%if(gubun1.equals("3")){%>selected<%}%>>당일</option>
                          <option value='1' <%if(gubun1.equals("1")){%>selected<%}%>>당월</option>
                          <option value='2' <%if(gubun1.equals("2")){%>selected<%}%>>기간 </option>
						  <option value='4' <%if(gubun1.equals("4")){%>selected<%}%>>출발 </option>
                        </select>
            			&nbsp;&nbsp;&nbsp;
            			<input type='text' size='11' name='st_dt' class='text' value='<%=st_dt%>'>
                            ~ 
                        <input type='text' size='11' name='end_dt' class='text' value="<%=end_dt%>">
        		    </td>				
                    <td class=title width=10%>지점</td>
                    <td width=40% colspan="3">&nbsp;
            		<select name='gubun2'>
						<option value='' >전체 </option>
                            <%if(brch_size > 0){
    				for (int i = 0 ; i < brch_size ; i++){
    					Hashtable branch = (Hashtable)branches.elementAt(i);%>
							
                            <option value='<%=branch.get("BR_ID")%>' <%if(gubun2.equals(String.valueOf(branch.get("BR_ID")))){%> selected <%}%>><%= branch.get("BR_NM")%></option>
                            <%	}
    		            }%>	            		
                        </select>
        		    </td>
                </tr>
        		<tr>
                    <td class=title width=10%>검색조건</td>
                    <td>&nbsp;
            		    <select name='s_kd' <%=disabled%>>
							<option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>탁송업체 </option>
							<option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>출발/도착장소</option>
							<option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>차량번호 </option>
							<option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>의뢰자</option>
							<option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>탁송번호</option>			  
							<option value='7' <%if(s_kd.equals("7")){%>selected<%}%>>기타내용</option>
							<option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>운전자</option>
							<option value='9' <%if(s_kd.equals("9")){%>selected<%}%>>청구금액</option>
                        </select>
            			&nbsp;&nbsp;&nbsp;
        			    <input type='text' name='t_wd' size='25' class='<%=white%>text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active' <%if(nm_db.getWorkAuthUser("아마존카이외",user_id)){%>readonly<%}%>>
        		    </td>
                    <td class=title width=10%>구분</td>
                    <td width=20%>&nbsp;
            		    <select name='gubun3'>
            			  <option value=''  <%if(gubun3.equals("")){ %>selected<%}%>>전체</option>
                          <option value='1' <%if(gubun3.equals("1")){%>selected<%}%>>담당자확인</option>
                          <option value='2' <%if(gubun3.equals("2")){%>selected<%}%>>관리자확인</option>
                          <option value='3' <%if(gubun3.equals("3")){%>selected<%}%>>담당자+관리자확인</option>
                          <option value='4' <%if(gubun3.equals("4")){%>selected<%}%>>담당자미확인</option>
                          <option value='5' <%if(gubun3.equals("5")){%>selected<%}%>>관리자미확인</option>
                        </select>
						<%//if(user_id.equals("000096")){%>
					<td class=title width=10%>정렬조건</td>
                    <td width=20%>&nbsp;	
						<select name='sort'>
                          <!--<option value='r' <%if(sort.equals("r")){%>selected<%}%>>담당자미확인</option>-->
						  <option value='1' <%if(sort.equals("1")){%>selected<%}%>>탁송번호</option>
                          <option value='2' <%if(sort.equals("2")){%>selected<%}%>>차량번호</option>
                          <option value='3' <%if(sort.equals("3")){%>selected<%}%>>출발일시</option>
						  
                        </select>
					</td>
						<%//}%>
        		    </td>		  
        		</tr>
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td colspan="2"><%//if(white.equals("")){%><a href="javascript:search();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif" align="absbottom" border="0"></a> <%//}%></td>
    </tr>
</table>
</form>
</body>
</html>
