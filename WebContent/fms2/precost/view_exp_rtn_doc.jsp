<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.insur.*"%>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function view_car_exp(car_mng_id){
		window.open('view_exp_car_list.jsp?car_mng_id='+car_mng_id, "VIEW_EXP_LIST", "left=0, top=0, width=850, height=768, scrollbars=yes, status=yes, resize");
	}

//-->
</script>
<link rel=stylesheet type="text/css" href="../../include/table_p.css">
<body>
<%
	String cost_ym 	= request.getParameter("cost_ym")==null?"":request.getParameter("cost_ym");
	String pay_yn 	= request.getParameter("pay_yn")==null?"":request.getParameter("pay_yn");
	String car_ext 	= request.getParameter("car_ext")==null?"":request.getParameter("car_ext");
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
<form name='form1' method='post'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
      <td align="center">(주)아마존카 선납 자동차세 환급 신청 리스트</td>
    </tr>  
    <tr>
      <td><%if(car_ext.equals("1")){%>영등포구청(홍주영:02-2670-3283, 환급신청:02-2670-3216, email:beads@ydp.go.kr)<%}else if(car_ext.equals("2")){%>파주시청(한명석:031-940-4231, fax:031-940-4219)<%}else if(car_ext.equals("6")){%>포천시청(신경숙: 031-538-2191, fax:031-538-2755)<%}else if(car_ext.equals("3")){%>부산<%}else if(car_ext.equals("4")){%>김해<%}else if(car_ext.equals("5")){%>대전<%}else if(car_ext.equals("7")){%>인천<%}else if(car_ext.equals("9")){%>광주<%}%></td>
    </tr>  		
	<tr>
	  <td class=line>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr valign="middle" align="center"> 
		    <td width='5%' class=title>연번</td>
		    <td width='10%' class=title>차량번호</td>
		    <td width='15%' class=title >차명</td>
		    <td width='10%' class=title>최초등록일</td>
		    <td width='30%' class=title>용도변경</td>
		    <td width='30%' class=title>명의이전</td>			
	      </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);%>
		  <tr> 
		    <td align='center'><a href="javascript:view_car_exp('<%=ht.get("CAR_MNG_ID")%>')"><%=i+1%></a></td>
		    <td align='center'><%=ht.get("CAR_NO")%></td>
		    <td align='center'><%=ht.get("CAR_NM")%></td>
		    <td align='center'><%=ht.get("INIT_REG_DT")%></td>			
		    <td>&nbsp;<%=ht.get("CHA_CONT")%></td>
		    <td>&nbsp;<%=ht.get("SUI_CONT")%></td>			
		  </tr>
  <%	 }%>
	    </table>
	  </td>
	</tr>
    <tr>
      <td>※ 연납당시 차량번호</td>
    </tr>  	
    <tr>
	  <td>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>
		    <td>&nbsp;</td>
		    <td colspan="2"><%=AddUtil.getDate3()%></td>
		  </tr>
		  <tr>
		    <td width='40%'>&nbsp;</td>
		    <td width='10%'>상호 :</td>
		    <td width='50%'>(주)아마존카</td>
		  </tr>
		  <tr>
		    <td>&nbsp;</td>
		    <td>법인번호 :</td>
		    <td>115611-0019610</td>
		  </tr>
		  <tr>
		    <td>&nbsp;</td>
		    <td>사업자번호 :</td>
		    <td>128-81-47957</td>
		  </tr>
		  <tr>
		    <td>&nbsp;</td>
		    <td>담당자 :</td>
		    <td>류길선 (dev@amazoncar.co.kr)</td>
		  </tr>
		  <tr>
		    <td>&nbsp;</td>
		    <td>연락처 :</td>
		    <td>tel:070-8224-8651 / fax:0506-200-1864</td>
		  </tr>
		  <tr>
		    <td>&nbsp;</td>
		    <td>환급계좌번호 :</td>
		    <td>신한은행 : 140-004-023871 </td>
		  </tr>
		</table>
	  </td>
	</tr>	
  </table>  
</form>  
</body>
</html>
