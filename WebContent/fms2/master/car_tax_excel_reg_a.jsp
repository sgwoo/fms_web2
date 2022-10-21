<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*"%>
<%@ page import="acar.con_tax.*, acar.offls_sui.*,acar.car_register.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="sBean" class="acar.offls_sui.SuiBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>


<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	
	String result0[]  = new String[value_line+10];
	String result1[]  = new String[value_line+10];
	String result2[]  = new String[value_line+10];
	String result3[]  = new String[value_line+10];
	String result4[]  = new String[value_line+10];
	String result5[]  = new String[value_line+10];
	String result6[]  = new String[value_line+10];
	String result7[]  = new String[value_line+10];
	String result8[]  = new String[value_line+10];
	String result9[]  = new String[value_line+10];
	String result10[]  = new String[value_line+10];
	String result11[]  = new String[value_line+10];
	String result12[]  = new String[value_line+10];
	
	String value0[]  = request.getParameterValues("value0");//���ʵ����
	String value1[]  = request.getParameterValues("value1");//�����ȣ
	String value2[]  = request.getParameterValues("value2");//������ȣ
	
	boolean flag = true;
	
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	for(int i=start_row ; i <= value_line ; i++){
		
		String init_reg_dt 		= value0[i] ==null?"":AddUtil.replace(value0[i]," ","");
		String car_num			= value1[i] ==null?"":AddUtil.replace(value1[i]," ","");
		String car_no 			= value2[i] ==null?"":AddUtil.replace(value2[i]," ",""); //AddUtil.replace(AddUtil.replace(value2[i]," ",""),"ȣ","��");
		
		result0[i] = "";
		result1[i] = "";
		result2[i] = "";
		result3[i] = "";
		result4[i] = "";
		result5[i] = "";
		result6[i] = "";
		result7[i] = "";
		result8[i] = "";
		result9[i] = "";
		result10[i] = "";
		result11[i] = "";
		result12[i] = "";
		
		//out.println("init_reg_dt="+init_reg_dt+",");
		//out.println("car_num="+car_num+",");
		//out.println("car_no="+car_no+",");
		
		//Ư�Ҽ�����
		TaxScdBean bean = t_db.getTaxScdExcelChk(init_reg_dt, car_num, car_no);
		
		//out.println("1�� Ȯ��");
		
		if(bean.getTax_st().equals("1")) result0[i] = "���뿩";
		if(bean.getTax_st().equals("2")) result0[i] = "�Ű�";
		
		result1[i] = bean.getPay_dt();
		result2[i] = String.valueOf(bean.getCar_fs_amt());
		result3[i] = bean.getSur_rate();
		result4[i] = bean.getTax_rate();
		result5[i] = String.valueOf(bean.getSpe_tax_amt());
		result6[i] = bean.getTax_come_dt();
		result7[i] = bean.getEst_dt();
		result8[i] = String.valueOf(bean.getSur_amt());
		result9[i] = String.valueOf(bean.getEdu_tax_amt());
		result10[i] = bean.getCar_mng_id();
		result11[i] = bean.getInit_reg_dt();
		result12[i] = bean.getCar_num();
		
		if(bean.getRent_l_cd().equals("")){
			//Ư�Ҽ�����
			bean = t_db.getTaxScdExcelChk2(init_reg_dt, car_num, car_no);
			
			//out.println("2�� Ȯ��");
			
			if(bean.getTax_st().equals("1")) result0[i] = "���뿩";
			if(bean.getTax_st().equals("2")) result0[i] = "�Ű�";
			
			result1[i] = bean.getPay_dt();
			result2[i] = String.valueOf(bean.getCar_fs_amt());
			result3[i] = bean.getSur_rate();
			result4[i] = bean.getTax_rate();
			result5[i] = String.valueOf(bean.getSpe_tax_amt());
			result6[i] = bean.getTax_come_dt();
			result7[i] = bean.getEst_dt();
			result8[i] = String.valueOf(bean.getSur_amt());
			result9[i] = String.valueOf(bean.getEdu_tax_amt());
			result10[i] = bean.getCar_mng_id();
			result11[i] = bean.getInit_reg_dt();
			result12[i] = bean.getCar_num();
			
			if(bean.getRent_l_cd().equals("")){
				result0[i] = "����";
				bean = t_db.getTaxScdExcelChk3(init_reg_dt, car_num, car_no);
				
				//out.println("3�� Ȯ��");
				
				if(bean.getTax_st().equals("1")) result0[i] = "���뿩";
				if(bean.getTax_st().equals("2")) result0[i] = "�Ű�";
				
				result1[i] = bean.getPay_dt();
				result2[i] = String.valueOf(bean.getCar_fs_amt());
				result3[i] = bean.getSur_rate();
				result4[i] = bean.getTax_rate();
				result5[i] = String.valueOf(bean.getSpe_tax_amt());
				result6[i] = bean.getTax_come_dt();
				result7[i] = bean.getEst_dt();
				result8[i] = String.valueOf(bean.getSur_amt());
				result9[i] = String.valueOf(bean.getEdu_tax_amt());
				result10[i] = bean.getCar_mng_id();
				result11[i] = bean.getInit_reg_dt();
				result12[i] = bean.getCar_num();
				
				if(bean.getRent_l_cd().equals("")){
					result0[i] = "����";
					bean = t_db.getTaxScdExcelChk4(init_reg_dt, car_num, car_no);
					
					//out.println("4�� Ȯ��");
					
					if(bean.getTax_st().equals("1")) result0[i] = "���뿩";
					if(bean.getTax_st().equals("2")) result0[i] = "�Ű�";
					
					result1[i] = bean.getPay_dt();
					result2[i] = String.valueOf(bean.getCar_fs_amt());
					result3[i] = bean.getSur_rate();
					result4[i] = bean.getTax_rate();
					result5[i] = String.valueOf(bean.getSpe_tax_amt());
					result6[i] = bean.getTax_come_dt();
					result7[i] = bean.getEst_dt();
					result8[i] = String.valueOf(bean.getSur_amt());
					result9[i] = String.valueOf(bean.getEdu_tax_amt());
					result10[i] = bean.getCar_mng_id();
					result11[i] = bean.getInit_reg_dt();
					result12[i] = bean.getCar_num();
					
					if(bean.getRent_l_cd().equals("")){
					
						result0[i] = "����";
						bean = t_db.getTaxScdExcelChk5(init_reg_dt, car_num, car_no);
					
						//out.println("5�� Ȯ��");
					
						if(bean.getTax_st().equals("1")) result0[i] = "���뿩";
						if(bean.getTax_st().equals("2")) result0[i] = "�Ű�";
					
						result1[i] = bean.getPay_dt();
						result2[i] = String.valueOf(bean.getCar_fs_amt());
						result3[i] = bean.getSur_rate();
						result4[i] = bean.getTax_rate();
						result5[i] = String.valueOf(bean.getSpe_tax_amt());
						result6[i] = bean.getTax_come_dt();
						result7[i] = bean.getEst_dt();
						result8[i] = String.valueOf(bean.getSur_amt());
						result9[i] = String.valueOf(bean.getEdu_tax_amt());
						result10[i] = bean.getCar_mng_id();
						result11[i] = bean.getInit_reg_dt();
						result12[i] = bean.getCar_num();
						
						
						if(bean.getRent_l_cd().equals("")){
						
							result10[i] = t_db.getCarIdExcelChk(init_reg_dt, car_num, car_no);
						
							//out.println("6�� Ȯ��");
						
							//�Ű�����
							sBean = olsD.getSui(result10[i]);
							//��������
							cr_bean = crd.getCarRegBean(result10[i]);
						
							if(!cr_bean.getCar_mng_id().equals("")){
								result11[i] = AddUtil.replace(cr_bean.getInit_reg_dt(),"-","");
								result12[i] = cr_bean.getCar_num();
							}
						
							if(!sBean.getCar_mng_id().equals("")){
								result7[i] = "��������";
								result6[i] = sBean.getMigr_dt();
							}
						}
					}
				}
			}
		}
		
		//if(1==1)return;
	}
	
	int result_cnt = 0;
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/info.js"></script>
<script language='javascript'>
<!--
	function view_car(c_id)
	{
		window.open("/fms2/precost/view_tax_car_list.jsp?car_mng_id="+c_id, "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");		
	}		
	function view_car_tax(c_id)
	{
		window.open("/acar/con_tax/tax_scd_c.jsp?c_id="+c_id, "VIEW_CAR", "left=10, top=10, width=1000, height=700, scrollbars=yes");		
	}			
//-->
</script>

</HEAD>
<BODY>
<form action="" method='post' name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
</form>
    <table border="0" cellspacing="0" cellpadding="0" width=1500>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ADMIN > <span class=style5>Ư�Ҽ�����Ȯ��</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr> 
        <td class=h>&nbsp;</td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr>
        <td align="right" class="line">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>

  <tr>
    <td rowspan="2" class=title>����</td>
    <td colspan="3" class=title>������</td>	
    <td colspan="12" class=title>�Ƹ���ī</td>	
    <!--<td rowspan="2" class=title>-</td>-->	
    <!--<td class=title>-</td>-->		
  </tr>
  <tr>
    <td class=title>���ʵ����</td>	
    <td class=title>�����ȣ</td>		
    <td class=title>������ȣ</td>			
    <td class=title>���ʵ����</td>	
    <td class=title>�����ȣ</td>		
    <td class=title>���α���</td>	
    <td class=title>�����߻���</td>
    <td class=title>��������</td>	
    <td class=title>��������</td>		
    <td class=title>�鼼���԰�</td>
    <td class=title>������</td>
    <td class=title>�����ݾ�</td>	
    <td class=title>Ư�Ҽ���</td>	
    <td class=title>Ư�Ҽ�</td>
    <td class=title>������</td>	
    <!--<td class=title>-</td>-->		
  </tr>
<%	for(int i=start_row ; i <= value_line ; i++){
		result_cnt++;%>  
  <tr>
    <td align="center"><%=i%></td>  
    <td align="center"><%=value0[i]%></td>
    <td align="center"><%=value1[i]%></td>	
    <td align="center"><%=value2[i]%></td>		
    <td align="center" <%if(!value0[i].equals(result11[i])){%>class='star'<%}%>><%=result11[i]%></td>	
    <td align="center" <%if(!value1[i].equals(result12[i])){%>class='star'<%}%>><%=result12[i]%></td>	
    <td align="center"><%=result0[i]%></td>			
    <td align="center"><%=result6[i]%></td>
    <td align="center"><%=result7[i]%></td>
    <td align="center"><%=result1[i]%></td>		
    <td align="right"><%=result2[i]%></td>
    <td align="center"><%=result3[i]%></td>		
    <td align="right"><%=result8[i]%></td>			
    <td align="center"><%=result4[i]%></td>			
    <td align="right"><%=result5[i]%></td>				
    <td align="right"><%=result9[i]%></td>					
    <!--<td align="center">[<%=i%>]&nbsp;<a href="javascript:parent.view_car('<%=result10[i]%>')" onMouseOver="window.status=''; return true">Ȯ��</a>
	&nbsp;<a href="javascript:parent.view_car_tax('<%=result10[i]%>')" onMouseOver="window.status=''; return true">����</a>
	</td>-->
  </tr>		
<%	}%>		
            </table>
		</td>
    </tr>
</table>

</BODY>
</HTML>