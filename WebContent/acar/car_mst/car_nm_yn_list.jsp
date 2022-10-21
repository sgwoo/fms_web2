<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String car_comp_id = request.getParameter("car_comp_id")==null?"0001":request.getParameter("car_comp_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String car_name = request.getParameter("car_name")==null?"":request.getParameter("car_name");
	String view_dt = request.getParameter("view_dt")==null?"":request.getParameter("view_dt");
	
	if(car_name.equals("전체")) car_name = "";
	if(car_name.equals("선택")) car_name = "";
	if(view_dt.equals("전체")) 	view_dt = "";
	if(view_dt.equals("선택")) 	view_dt = "";
	if(!car_name.equals(""))	view_dt = "";
	
	AddCarMstDatabase a_cmd = AddCarMstDatabase.getInstance();
	
	Vector vt = a_cmd.getCarNmExcelYnList(car_comp_id, car_cd, car_name, view_dt);
	int vt_size = vt.size();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript">
<!--
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_id"){
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
	}	
	
	//등록하기
	function save(){
		fm = document.form1;
		
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_id"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("일괄 지출 처리할 건을 선택하세요.");
			return;
		}	
				
		if(!confirm("등록하시겠습니까?"))	return;
		fm.action = 'car_nm_yn_list_a.jsp';
		fm.submit();
	}
	
	//등록하기
	function save2(){
		fm = document.form1;
		
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_id"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("일괄 지출 처리할 건을 선택하세요.");
			return;
		}	
				
		if(!confirm("등록하시겠습니까?"))	return;
		fm.action = 'car_nm_yn_list_a2.jsp';
		fm.submit();
	}	
//-->
</script>
</head>
<body>
<form action="" method='post' name="form1">
<input type='hidden' name='size' value='<%=vt_size%>'>
<input type='hidden' name='car_comp_id' value='<%=car_comp_id%>'>
<input type='hidden' name='car_cd' value='<%=car_cd%>'>
<input type='hidden' name='car_name' value='<%=car_name%>'>
<input type='hidden' name='view_dt' value='<%=view_dt%>'>


<table border=0 cellspacing=0 cellpadding=0 width=780>
	<tr>
		<td><일괄 미사용 처리>
		</td>	
	</tr>	
    <tr>
        <td>            
            <table border=1 cellspacing=1 width=100%>
			  <tr>
			    <td width="30" align="center">연번</td>
			    <td width="100"  align="center">제조사</td>
			    <td width="100" align="center">차명</td>
			    <td width="200" align="center">모델</td>
			    <td width="100" align="center">기본가격</td>
				<!--
			    <td width="60"  align="center">모델코드</td>				
			    <td width="60"  align="center">일련번호</td>		
			    <td width="60"  align="center">차종코드</td>												
				-->
			    <td width="80"  align="center">기준일자</td>
			    <!--<td width="80"  align="center">단종일자<br>(가격표에서<br>빠진날)</td>-->
			    <td width="60"  align="center">사용여부</td>		
			    <td width="60"  align="center">견적여부</td>						
			    <td width="50"  align="center"><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
			  </tr>
			  <%for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					%>
			  <tr>
			    <td  align="center"><%=i+1%></td>
			    <td ><%=ht.get("NM")%></td>
			    <td ><%=ht.get("CAR_NM")%></td>
			    <td >&nbsp;<%=ht.get("CAR_NAME")%></td>
			    <td  align="right"><%=ht.get("CAR_B_P")%></td>
				<!--
			    <td  align="center">&nbsp;<%=ht.get("CAR_ID")%></td>
			    <td  align="center">&nbsp;<%=ht.get("CAR_SEQ")%></td>	
			    <td  align="center"><%=ht.get("JG_CODE")%></td>
				-->
			    <td  align="center"><%=ht.get("CAR_B_DT")%></td>
				<!--<td align="center">&nbsp;<%=ht.get("END_DT")%></td>-->
			    <td  align="center"><%=ht.get("USE_YN")%></td>		
			    <td  align="center"><%=ht.get("EST_YN")%></td>						
				<td align="center"><input type="checkbox" name="ch_id" value="<%=ht.get("CAR_ID")%>/<%=ht.get("CAR_SEQ")%>"></td>				
			  </tr>
			  <%}%>
            </table>
        </td>
    </tr>
	<tr>
		<td align='right'>
		  <a href="javascript:save()">[미사용처리]</a>&nbsp;&nbsp;
		  <a href="javascript:save2()">[사용처리]</a>&nbsp;&nbsp;
		  <a href='javascript:window.close();'><img src=../images/center/button_close.gif align=absmiddle border=0></a>
		</td>	
	</tr>		
</table>
</form>
</body>
</html>