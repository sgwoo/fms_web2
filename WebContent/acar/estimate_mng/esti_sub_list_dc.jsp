<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiCarVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq = request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	
	//차종변수별 리스트
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	Vector vars = e_db.getCarSubList(idx, car_comp_id, car_cd, car_id, car_seq);
	int size = vars.size();
	
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function setCode(id, seq, nm, amt, s_st){
		var fm = opener.document.form1;				
		<%if(idx.equals("1")){%>
		fm.car_name.value = nm;
		fm.car_id.value = id;
		fm.car_seq.value = seq;
		fm.car_amt.value = parseDecimal(amt);
		fm.s_st.value = s_st;
		opener.lpg_display();
		<%}else if(idx.equals("2")){%>
		fm.opt.value = nm;
		fm.opt_seq.value = id;
		fm.opt_amt.value = parseDecimal(amt);		
		<%}else if(idx.equals("3")){%>
		fm.col.value = nm;
		fm.col_seq.value = id;
		fm.col_amt.value = parseDecimal(amt);
		<%}else if(idx.equals("4")){%>
		fm.dc.value = nm;
		fm.dc_seq.value = id;
		fm.dc_amt.value = parseDecimal(amt);
		<%}%>
		fm.o_1.value = parseDecimal(toInt(parseDigit(fm.car_amt.value)) + toInt(parseDigit(fm.opt_amt.value)) + toInt(parseDigit(fm.col_amt.value)) - toInt(parseDigit(fm.dc_amt.value)));
		self.close();
	}
	
	function save(){
		var ofm = opener.document.form1;
		var fm = document.form1;
		var len=fm.elements.length;
		var cnt=0;
		var codes="";
		var amts=0;	
		var opts="";		
		var o_split;
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "car_s_seq"){		
				if(ck.checked == true){
					cnt++;
					o_split = ck.value.split("||");	
					codes += o_split[0];
					opts += o_split[1]+"  ";
					amts += toInt(o_split[2]);					
				}
			}
		}	
		if(cnt == 0){
		 	alert("선택사양을 선택하세요.");
			return;
		}
		ofm.opt.value = opts;
		ofm.opt_seq.value = codes;
		ofm.opt_amt.value = parseDecimal(amts);		
		ofm.o_1.value = parseDecimal(toInt(parseDigit(ofm.car_amt.value)) + toInt(parseDigit(ofm.opt_amt.value)) + toInt(parseDigit(ofm.col_amt.value)) - toInt(parseDigit(ofm.dc_amt.value)));		
		self.close();
	}
	
//-->
</script>
</head>
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='size' value='<%=size%>'>
<table border=0 cellspacing=0 cellpadding=0 width=550>
  <tr> 
    <td>< <%if(idx.equals("1")) {%>차종 <%}else if(idx.equals("2")){%>옵션 <%}else if(idx.equals("3")){%>색상 <%}else{%>제조사DC<%}%> ></td>
  </tr>
  <tr> 
    <td class=line>
        <table border=0 cellspacing=1 width=550>
          <tr> 
            <td class="title" width="30"><%if(idx.equals("2")) {%>선택 <%}else{%>연번 <%}%></td>
            <td class="title" width="400">종류</td>
            <td class="title" width="120">가격</td>
        </tr>
          <%for(int i = 0 ; i < size ; i++){
				Hashtable var = (Hashtable)vars.elementAt(i);%>		
        <tr> 
            <td align="center"><%if(idx.equals("2")){%><input type="checkbox" name="car_s_seq" value='<%=var.get("ID")%>||<%=var.get("NM")%>||<%=var.get("AMT")%>'><%}else{%>            
            <%=i+1%><%}%></td>
            <td>&nbsp;<a href="javascript:setCode('<%=var.get("ID")%>', '<%=var.get("SEQ")%>', '<%=var.get("NM")%>', '<%=var.get("AMT")%>', '<%=var.get("S_ST")%>');"><%=var.get("NM")%></a></td>
            <td align="right">&nbsp;<%=AddUtil.parseDecimal(String.valueOf(var.get("AMT")))%>원&nbsp;&nbsp;</td>						
        </tr>
          <%}%>		
      </table>
    </td>
  </tr>
  <%if(idx.equals("2")){%>
  <tr> 
    <td align="right"> 
      <input type="button" name="b_selete" value="확인" onClick="javascript:save();">
    </td>
  </tr>  
  <%}else{%>  
  <tr> 
      <td align="right"> <a href="javascript:self.close();">닫기</a> </td>
  </tr>  
  <%}%>  
</table>
</form>
</body>
</html>