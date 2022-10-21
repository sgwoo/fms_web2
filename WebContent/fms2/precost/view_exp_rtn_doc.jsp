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
	
	//�ڵ����� ����Ʈ
	vts = ai_db.getExpRtnScdReqList(car_ext);
	vt_size = vts.size();
%>
<form name='form1' method='post'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
      <td align="center">(��)�Ƹ���ī ���� �ڵ����� ȯ�� ��û ����Ʈ</td>
    </tr>  
    <tr>
      <td><%if(car_ext.equals("1")){%>��������û(ȫ�ֿ�:02-2670-3283, ȯ�޽�û:02-2670-3216, email:beads@ydp.go.kr)<%}else if(car_ext.equals("2")){%>���ֽ�û(�Ѹ�:031-940-4231, fax:031-940-4219)<%}else if(car_ext.equals("6")){%>��õ��û(�Ű��: 031-538-2191, fax:031-538-2755)<%}else if(car_ext.equals("3")){%>�λ�<%}else if(car_ext.equals("4")){%>����<%}else if(car_ext.equals("5")){%>����<%}else if(car_ext.equals("7")){%>��õ<%}else if(car_ext.equals("9")){%>����<%}%></td>
    </tr>  		
	<tr>
	  <td class=line>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr valign="middle" align="center"> 
		    <td width='5%' class=title>����</td>
		    <td width='10%' class=title>������ȣ</td>
		    <td width='15%' class=title >����</td>
		    <td width='10%' class=title>���ʵ����</td>
		    <td width='30%' class=title>�뵵����</td>
		    <td width='30%' class=title>��������</td>			
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
      <td>�� ������� ������ȣ</td>
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
		    <td width='10%'>��ȣ :</td>
		    <td width='50%'>(��)�Ƹ���ī</td>
		  </tr>
		  <tr>
		    <td>&nbsp;</td>
		    <td>���ι�ȣ :</td>
		    <td>115611-0019610</td>
		  </tr>
		  <tr>
		    <td>&nbsp;</td>
		    <td>����ڹ�ȣ :</td>
		    <td>128-81-47957</td>
		  </tr>
		  <tr>
		    <td>&nbsp;</td>
		    <td>����� :</td>
		    <td>���漱 (dev@amazoncar.co.kr)</td>
		  </tr>
		  <tr>
		    <td>&nbsp;</td>
		    <td>����ó :</td>
		    <td>tel:070-8224-8651 / fax:0506-200-1864</td>
		  </tr>
		  <tr>
		    <td>&nbsp;</td>
		    <td>ȯ�ް��¹�ȣ :</td>
		    <td>�������� : 140-004-023871 </td>
		  </tr>
		</table>
	  </td>
	</tr>	
  </table>  
</form>  
</body>
</html>
