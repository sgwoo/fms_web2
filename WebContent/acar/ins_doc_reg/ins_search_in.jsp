<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"2":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");	
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");	
	
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	if(!st_dt.equals("")) 	st_dt 	= AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) 	end_dt 	= AddUtil.replace(end_dt, "-", "");
	
	Vector inss = ai_db.getInsClsMngList_200704(t_wd, gubun1, gubun2, st_dt, end_dt, car_no, sort);
	int ins_size = inss.size();	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "cho_id"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}	
		}
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width="6%" rowspan="2" class='title'>연번</td>
                    <td width="6%" rowspan="2" class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
                    <td width='12%' rowspan="2" class='title'>해지구분</td>
                    <td colspan="2" class='title'>차량번호</td>
                    <td width='22%' rowspan="2" class='title'>차량명</td>
                    <td width='13%' rowspan="2" class='title'>해지사유<br>발생일자</td>
                    <td width='13%' rowspan="2" class='title'>청구일자</td>
                </tr>
                <tr>
                    <td width='14%' class='title'>변경전</td>
                    <td width='14%' class='title'>변경후</td>
                </tr>
              <% 		for (int i = 0 ; i < ins_size ; i++){
    			Hashtable ins = (Hashtable)inss.elementAt(i);%>		  
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td> 
                      <input type="checkbox" name="cho_id" value="<%=ins.get("CAR_MNG_ID")%><%=ins.get("INS_ST")%>">
                    </td>
                    <td><%=ins.get("CAU")%></td>
                    <td><%=ins.get("BE_CAR_NO")%></td>
                    <td><%=ins.get("CAR_NO")%></td>
                    <td><span title='<%=ins.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ins.get("CAR_NM")), 7)%></span></td>
                    <td><%=AddUtil.ChangeDate2(String.valueOf(ins.get("EXP_DT")))%></td>
                    <td><%=AddUtil.ChangeDate2(String.valueOf(ins.get("REQ_DT")))%></td>
                </tr>
              <%		}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
