<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.insur.*"%>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	String pay_dt = request.getParameter("pay_dt")==null?"":request.getParameter("pay_dt");//����-��������
	String est_dt = request.getParameter("est_dt")==null?"":request.getParameter("est_dt");//����-��������
	
	String result[]  = new String[value_line];
	String value0[]  = request.getParameterValues("value0");//�̰ᱸ��
	String value1[]  = request.getParameterValues("value1");//����
	String value2[]  = request.getParameterValues("value2");//���ù�ȣ
	String value3[]  = request.getParameterValues("value3");//�ݾ�
	String value4[]  = request.getParameterValues("value4");//��������
	String value5[]  = request.getParameterValues("value5");//���밳������
	String value6[]  = request.getParameterValues("value6");//����ȣ(���ǹ�ȣ)
	String value7[]  = request.getParameterValues("value7");//�Է�����
	String value8[]  = request.getParameterValues("value8");//���
	String value9[]  = request.getParameterValues("value9");
	String value10[] = request.getParameterValues("value10");
	String value11[] = request.getParameterValues("value11");
	String value12[] = request.getParameterValues("value12");
	String value13[] = request.getParameterValues("value13");
	String value14[] = request.getParameterValues("value14");
	String value15[] = request.getParameterValues("value15");
	String value16[] = request.getParameterValues("value16");
	String value17[] = request.getParameterValues("value17");
	String value18[] = request.getParameterValues("value18");
	String value19[] = request.getParameterValues("value19");
	
	out.println(start_row);
	out.println(value_line);
	
	
	String ins_con_no 	= "";
	int    ins_amt	 	= 0;
	
	int flag 			= 0;
	boolean flag2 		= true;
	int result2 		= 0;
	
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	for(int i=start_row ; i < value_line ; i++){
	
		ins_amt 		= value3[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(AddUtil.replace(value3[i]," ",""),"_",""));
		ins_con_no 		= value6[i] ==null?"":                   AddUtil.replace(AddUtil.replace(value6[i]," ",""),"_","");
		result[i] 		= "";
		
		out.println(ins_amt);
		out.println(ins_con_no);
		
		
		if(!ins_con_no.equals("")){
		
			//���� ��ȸ-------------------------------------------------
			InsurScdBean scd = ai_db.getInsExcelScdCase(ins_con_no, est_dt, ins_amt);
			
			//�������� ��ȸ
			InsurBean ins = ai_db.getInsConNoExcelCase(ins_con_no);
			
			out.println("ins.getCar_mng_id()="+scd.getCar_mng_id()+",<br>");
			out.println("ins.getIns_st()="+scd.getIns_st()+",<br>");
			out.println("ins.getIns_tm()="+scd.getIns_tm()+",<br>");			
			out.println("ins_con_no="+ins_con_no+",<br>");
			out.println("est_dt="+est_dt+",<br>");
			out.println("ins_amt="+ins_amt+",<br>");
			
			//if(1==1)return;
			
			
			if(scd.getCar_mng_id().equals("")){
				result[i] = "���� �������� ���ų� �̹� ����ó�� �Ǿ����ϴ�.";
				//���� ��ȸ-------------------------------------------------
				InsurScdBean scd2 = ai_db.getInsExcelScdAmtCase(ins_con_no, est_dt);
				if(scd2.getPay_amt()>0 || scd2.getPay_amt()<0){
					result[i] = result[i] + " <font color=blue>"+est_dt+"���� ������ �հ�="+scd2.getPay_amt()+"</font>";
					if(scd2.getPay_amt()>ins_amt || scd2.getPay_amt()<ins_amt){
						result[i] = result[i] + ", <font color=red>�����ݾװ� Ʋ���ϴ�.(����"+(scd2.getPay_amt()-ins_amt)+")</font>";
					}
				}
			}else{
				result[i] = "�������� �ֽ��ϴ�.";
				if(!pay_dt.equals("")){
					//���轺���� ����ó�� ------------------------------------------
					scd.setPay_dt(pay_dt);
					scd.setPay_yn("1");
					scd.setExcel_chk("1");
					if(ins.getIns_com_id().equals("0008")){
						String ins_est_dt = scd.getIns_est_dt();
						scd.setIns_est_dt(ins_est_dt.substring(0,6) +"15");
					}
					
					if(!ai_db.updateInsScd(scd)) flag += 1;
					
					if(flag != 0)	result[i] = "���� ����ó���� ���� �߻�";
					else			result[i] = "���� ����ó���Ǿ����ϴ�.";
				}
			}
		}
	}
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
  <tr>
    <td>&lt; ���� ���� ���� ó�� ��� &gt; </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>      
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>  
        <tr>
    	  <td width="30" class="title">����</td>
    	  <td width="100" class="title">���ǹ�ȣ</td>
    	  <td width="100" class="title">�ݾ�</td>
    	  <td class="title">ó�����</td>
        </tr>
<%	for(int i=start_row ; i < value_line ; i++){
		if(result[i].equals("�������� �ֽ��ϴ�.")) continue;%>		
        <tr>
          <td align="center"><%=i+1%></td>
          <td align="center"><%=value6[i] ==null?"":AddUtil.replace(value6[i],"_ ","")%></td>
          <td align="center"><%=value3[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value3[i],"_ ",""))%></td>
          <td>&nbsp;<%=result[i]%></td>		  
        </tr>
<%	}%>		
	  </table>
	</td>
  </tr>  
  <tr>
    <td align="center">&nbsp;</td>
  </tr>  
  <tr>  
    <td align="center"><a href='javascript:print()' onMouseOver="window.status=''; return true"><img src="/images/print.gif" width="50" height="18" aligh="absmiddle" border="0"></a>&nbsp;
	<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
    </tr>
</table>
</BODY>
</HTML>