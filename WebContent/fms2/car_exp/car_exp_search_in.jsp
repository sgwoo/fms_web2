<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.insur.*"%>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String cost_ym 	= request.getParameter("cost_ym")==null?"":request.getParameter("cost_ym");
	String pay_yn 	= request.getParameter("pay_yn")==null?"":request.getParameter("pay_yn");
	String car_ext 	= request.getParameter("car_ext")==null?"":request.getParameter("car_ext");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();


	car_ext = c_db.getIdByNameCode("0032", t_wd.substring(0,2)) ;
	
	int total_su = 0;
	long total_amt = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	
	
	Vector vts = new Vector();
	int vt_size = 0;
	
	
	
	
	//자동차세 리스트
	vts = ai_db.getExpRtnScdReqList(car_ext);
	vt_size = vts.size();
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
		return;
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>   
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width="6%">연번</td>
					<td class='title' width=4%><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
                    <td width='10%' class=title>차량번호</td>
					<td width='15%' class=title >차명</td>
					<td width='10%' class=title>최초등록일</td>
					<td width='10%' class=title>최종납부일</td>
					<td width='20%' class=title>용도변경</td>
					<td width='25%' class=title>명의이전</td>		
                </tr>
              <%		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);%>
				<tr> 
					<td align='center'><a href="javascript:view_car_exp('<%=ht.get("CAR_EXT")%>')"><%=i+1%></a></td>
					<td align='center'> 
                      <input type="checkbox" name="cho_id" value="<%=ht.get("CAR_NO")%>^<%=ht.get("CAR_EXT")%>^<%=ht.get("CAR_MNG_ID")%>^<%=ht.get("EXP_DT")%>">
                    </td>
					<td align='center'><%=ht.get("CAR_NO")%></td>
					<td align='center'><%=ht.get("CAR_NM")%></td>
					<td align='center'><%=ht.get("INIT_REG_DT")%></td>			
					<td align='center'><%=ht.get("EXP_DT")%></td>			
					<td>&nbsp;<%=ht.get("CHA_CONT")%></td>
					<td>&nbsp;<%=ht.get("SUI_CONT")%></td>			
				</tr>
				<%	 }%>
				
            </table>
        </td>
    </tr>
	<tr>
					<td colspan="7">※ 연납당시 차량번호</td>
				</tr> 
</table>
</form>
</body>
</html>
