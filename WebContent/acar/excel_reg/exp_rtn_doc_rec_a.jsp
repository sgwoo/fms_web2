<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.insur.*"%>
<%@ page import="acar.mng_exp.*"%>
<jsp:useBean id="ex_db" scope="page" class="acar.mng_exp.GenExpDatabase"/>


<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	String exp_st 	= "3";	//����-����(3:�ڵ�����)
	String exp_year = request.getParameter("exp_year")==null?"":request.getParameter("exp_year");			//�ΰ��⵵
	
	String result[]  = new String[value_line];
	String value0[]  = request.getParameterValues("value0");//������ȣ
	String value1[]  = request.getParameterValues("value1");//ȯ�ޱݾ�
	String value2[]  = request.getParameterValues("value2");//
	
	String car_mng_id 	= "";
	String car_no 		= "";
	String exp_start_dt = "";
	String exp_end_dt 	= "";
	String exp_est_dt 	= "";
	String exp_dt 		= "";
	int    exp_amt 		= 0;
	String rtn_dt		= "";
	boolean flag = true;
	
	
	
	for(int i=start_row ; i < value_line ; i++){
	
		car_no 			= value0[i] ==null?"":value0[i];
		exp_amt			= value1[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value1[i],"_ ",""));
		rtn_dt 			= value2[i] ==null?"":value2[i];
		
		//��Ÿ��� ����ó�� ------------------------------------------
		
		GenExpBean exp = ex_db.getGenExpRtnDoc(exp_st, car_no, exp_year);
		
		if(exp.getCar_mng_id().equals("")){
			result[i] = "��ȸ���� �ʽ��ϴ�.";
		}else{
			//����
			exp.setRtn_amt(exp_amt);
			exp.setRtn_dt(rtn_dt);
			exp.setCar_mng_id(exp.getCar_mng_id());
			exp.setExp_est_dt(exp_year);
			if(ex_db.updateGenExp2(exp)){
				//��������
				result[i] = "����ó���Ǿ����ϴ�.";
			}else{
				//��������
				result[i] = "������ ���� �߻�";
			}
		}
	}
	
	String ment = "";
	for(int i=start_row ; i < value_line ; i++){
		if(!result[i].equals("")) ment += result[i]+"";
	}
	int result_cnt = 0;
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<link rel=stylesheet type="text/css" href="../../include/table.css">
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
	function pagesetPrint(){
		print();
	}
//-->
</SCRIPT>
<style type="text/css">
<!--
.style1 {color: #999999}
-->
</style>
</HEAD>
<BODY>
<p>���� ���� �о� ���� ����ϱ�
</p>
<form action="excel_result.jsp" method='post' name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
</form>
<table border="0" cellspacing="0" cellpadding="0" width="570">
  <tr>
    <td>&lt; ���� ���� ó�� ��� &gt; </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>      
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>  
        <tr>
    	  <td width="30" class="title">����</td>
    	  <td width="100" class="title">-</td>
    	  <td width="100" class="title">-</td>
    	  <td class="title">ó�����</td>
        </tr>
<%	for(int i=start_row ; i < value_line ; i++){
		result_cnt++;%>
        <tr>
          <td align="center"><%=i+1%></td>
          <td align="center"><%=value0[i] ==null?"":value0[i]%></td>
          <td align="center"><%=value1[i] ==null?"":value1[i]%></td>
          <td>&nbsp;<%=result[i] ==null?"":result[i]%></td>		  
        </tr>
<%	}%>		
	  </table>
	</td>
  </tr>  
  <tr>
    <td align="center">&nbsp;</td>
  </tr>  
  <tr>  
    <td align="center"><a href='javascript:pagesetPrint()' onMouseOver="window.status=''; return true"><img src="/images/print.gif" width="50" height="18" aligh="absmiddle" border="0"></a>&nbsp;
	<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
    </tr>
</table>
</BODY>
</HTML>