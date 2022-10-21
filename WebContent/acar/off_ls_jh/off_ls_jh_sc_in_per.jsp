<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.offls_actn.*"%>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");//auction_seq
	String actn_cnt = request.getParameter("actn_cnt")==null?"":request.getParameter("actn_cnt");

	Offls_per_talkBean[] pts = olaD.getPer_talk(car_mng_id, actn_cnt);
	Offls_auctionBean auction = olaD.getAuction(car_mng_id, seq);
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
function updPer_talk(arg){
	var fm = document.form1;
	if(arg=='n'){
		if(fm.nak_pr.value==""){ alert('���������� �Է��� �ּ���.'); return; }
		if(!confirm('���� �Ͻð����ϱ�?')) return;
	}else if(arg=='r'){
		if(!confirm('���� �Ͻð����ϱ�?')) return;
	}else if(arg=='c'){
		if(!confirm('�������� �Ͻð����ϱ�?')) return;
	}
	fm.gubun.value = arg;
	fm.action = "off_ls_jh_sc_in_per_upd.jsp";
	fm.target = "i_no";
	fm.submit();
}
-->
</script>

</head>

<body bgcolor="#FFFFFF" text="#000000">
<%if(seq.equals(olaD.getAuction_maxSeq(car_mng_id))){//�ֱٰ�ŷ��ڵ��ϰ��%>
<form name="form1" action="" method="post">
<table width="800" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td> 
      <table width="800" border="0" cellspacing="1" cellpadding="0">
        <tr> 
          <td  >&lt;&lt; ������� &gt;&gt;
		  <%if(auction.getNak_pr() ==0){%>
		                      <input type="button" name="nak" value="����" onClick="javascript:updPer_talk('n');">
                    <input type="button" name="retalk" value="����" onClick="javascript:updPer_talk('r');">
					<input type="button" name="choi" value="��������" onClick="javascript:updPer_talk('c');">					
			<%}%>
		  </td>
        </tr>
        <tr> 
          <td class="line"  > 
              <table border="0" cellspacing="1" cellpadding='0' width="800" >
                <tr> 
                  <td class='title' width='50'>ȸ��</td>
                  <td class='title' width="120">�����þ�</td>
                  <td class='title' width="120">������þ�</td>
                  <td class='title' width="120">��������</td>
                  <td class='title'>����</td>
                </tr>
	<%if(pts.length > 0 ){
		for(int i=0; i<pts.length; i++){
			Offls_per_talkBean per_talk = pts[i];%>
	                <tr> 
	                  <td align="center" width="50" height="21"><%=per_talk.getSeq()%></td>
	                  <td align="center" width="120" height="21"><%=AddUtil.parseDecimal(per_talk.getCust_pr())%></td>
	                  <td align="center" width="120" height="21"><%=AddUtil.parseDecimal(per_talk.getAma_pr())%></td>
	                  <td align="center" width="120" height="21">
	                  </td>
	                  <td align="center" height="21"><%=per_talk.getReason()%></td>
	                </tr>
	   <%}
	}

	if(auction.getNak_pr() ==0){%>
                <tr> 
                  <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
                  <input type="hidden" name="seq" value="<%=seq%>">
				  <input type="hidden" name="actn_cnt" value="<%=actn_cnt%>">
                  <input type="hidden" name="gubun" value="">
                  <td align="center" width="50" height="21">&nbsp;</td>
                  <td align="center" width="120" height="21"> 
                    <input class="num" type="text" name="cust_pr" size="15" onBlur='javascript:this.value=parseDecimal(this.value)'>
                  </td>
                  <td align="center" width="120" height="21"> 
                    <input class="num" type="text" name="ama_pr" size="15" onBlur='javascript:this.value=parseDecimal(this.value)'>
                  </td>
                  <td align="center" width="120" height="21"> 
                    <input class="num" type="text" name="nak_pr" size="15" onBlur='javascript:this.value=parseDecimal(this.value)'>
                  </td>
                  <td  height="21"> 
                    <input class="text" type="text" name="reason" size="50">
                  </td>
                </tr>
              
              </table>
          </td>
        </tr>
        
	<%}%>  
      </table>
    </td>
  </tr>
</table>
</form>
<%}else{%>
<table width="800" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td> 
      <table width="800" border="0" cellspacing="1" cellpadding="0">
        <tr> 
          <td  >&lt;&lt; ������� &gt;&gt;
		  </td>
        </tr>
        <tr> 
          <td class="line"  > 
              <table border="0" cellspacing="1" cellpadding='0' width="800" >
                <tr> 
                  <td class='title' width='50'>ȸ��</td>
                  <td class='title' width="120">�����þ�</td>
                  <td class='title' width="120">������þ�</td>
                  <td class='title' width="120">��������</td>
                  <td class='title'>����</td>
                </tr>
  <%if(pts.length > 0 ){
	for(int i=0; i<pts.length; i++){
		Offls_per_talkBean per_talk = pts[i];
			  %>
                <tr> 
                  <td align="center" width="50" height="21"><%=per_talk.getSeq()%>ȸ��</td>
                  <td align="center" width="120" height="21"><%=AddUtil.parseDecimal(per_talk.getCust_pr())%></td>
                  <td align="center" width="120" height="21"><%=AddUtil.parseDecimal(per_talk.getAma_pr())%></td>
                  <td align="center" width="120" height="21"> 
                  </td>
                  <td align="center" height="21"><%=per_talk.getReason()%></td>
                </tr>
   <%}
  }else{%>
			<tr> 
               <td colspan="5" align="center">��� ������ �����ϴ�.</td>
           </tr>
 <%}%>
      </table>
    </td>
  </tr>
</table>
<%}%>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
