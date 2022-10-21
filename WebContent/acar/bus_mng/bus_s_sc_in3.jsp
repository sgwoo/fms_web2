<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");	
	
	int t_su = 0;
%>
<form name='form1' action='../ins_mng/ins_u_frame.jsp' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type="hidden" name="sort" value="<%=sort%>">
<input type="hidden" name="asc" value="<%=asc%>">
<input type='hidden' name='bus_id' value=''>
<input type='hidden' name='bus_nm' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>      		
        <td class='line'> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td rowspan="2" width="5%" class='title' align="center">연번</td>                    
                    <td rowspan="2" width="5%" class='title' align="center">지점</td>
                    <td rowspan="2" width="10%" class='title' align="center">성명</td>
                    <td colspan="2" class='title' align="center">합계</td>
                    <td colspan="2" class='title' align="center">일반식</td>
                    <td colspan="2" class='title' align="center">기본식</td>
                    <td rowspan="2" class='title' align="center" width=10%>연체율</td>
                </tr>
                <tr align="center"> 
                    <td width="10%" class='title'>대수</td>
                    <td width="20%" class='title'>받을어음</td>
                    <td width="5%" class='title'>대수</td>                    
                    <td width="15%" class='title'>받을어음</td>
                    <td width="5%" class='title'>대수</td>
                    <td width="15%" class='title'>받을어음</td>
                </tr>
                <%	//차량배정에 따른 채권 현황
			Vector vt = ad_db.getDlyBusStatMD2(br_id, sort, asc);
			int vt_size = vt.size();
			if(vt_size > 0){
				for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
		%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=ht.get("LOAN_ST")%> <%=ht.get("BR_ID")%></td>
                    <td align="center"><%=ht.get("USER_NM")%></td>
                    <td align="center"><%=ht.get("CNT0")%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("FEE_AMT0")))%></td>
                    <td align="center"><%=ht.get("CNT1")%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("FEE_AMT1")))%></td>
                    <td align="center"><%=ht.get("CNT2")%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("FEE_AMT2")))%></td>
                    <td align="center"><%=ht.get("PER0")%>%</td>
                </tr>
          <%		
		  		}
			}else{%>
                <tr> 
                    <td colspan="10" align="center">자료가 없습니다.</td>
                </tr>
          <%		}%>
            </table>
        </td>
    </tr>  		
 </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
