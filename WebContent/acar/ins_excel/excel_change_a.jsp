<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.common.*, acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	out.println("start_row="+start_row);
	out.println("value_line="+value_line+"<br><br>");
	
	
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	
	String result[]   = new String[value_line];
	String value0[]  	= request.getParameterValues("value0");	//1 ������ȣ
	String value1[]  	= request.getParameterValues("value1");	//2 ����
	String value2[]  	= request.getParameterValues("value2");	//3 ��ȣ��
	String value3[]  	= request.getParameterValues("value3");	//4 ����ڹ�ȣ
	String value4[]  	= request.getParameterValues("value4");	//5 �뿩������
	String value5[]  	= request.getParameterValues("value5");	//6 �뿩������
	String value6[]  	= request.getParameterValues("value6");	//7 ����������
	String value7[]  	= request.getParameterValues("value7");	//8 ����ȸ��
	String value8[]  	= request.getParameterValues("value8");	//9 ���������
	String value9[]  	= request.getParameterValues("value9");	//10 ���踸����
	String value10[] 	= request.getParameterValues("value10");//11 �����ĺ���
	String value11[] 	= request.getParameterValues("value11");//12 ������		
	String value12[] 	= request.getParameterValues("value12");//13 �̰��Խ���
	String value13[] 	= request.getParameterValues("value13");//14 �����׸�
	String value14[] 	= request.getParameterValues("value14");//15 ������
	String value15[] 	= request.getParameterValues("value15");//16 ������
	String value16[] 	= request.getParameterValues("value16");//17 �輭������
	String value17[] 	= request.getParameterValues("value17");//18 ��¡�����
	String value18[] 	= request.getParameterValues("value18");//19 ���ǹ�ȣ
	String value19[] 	= request.getParameterValues("value19");//20 ���ι��
	String value20[] 	= request.getParameterValues("value20");//21 ���ι��
	String value21[] 	= request.getParameterValues("value21");//22 �빰���
	String value22[] 	= request.getParameterValues("value22");//23 �ڱ��ü���
	String value23[] 	= request.getParameterValues("value23");//24 ������������
	String value24[] 	= request.getParameterValues("value24");//25 �д����������
	String value25[] 	= request.getParameterValues("value25");//26 �ڱ���������
	String value26[] 	= request.getParameterValues("value26");//27 �ִ�ī
	String value27[] 	= request.getParameterValues("value27");//28 �Ѻ����
			
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	int flag = 0;
	int count = 0;
	String v1 ="";
	String v2 ="";
	String v3 ="";
	String v4 ="";
	String v5 ="";
	String v6 ="";
	String v7 ="";
	String v8 ="";
	String v9 ="";
	String v10 ="";
	String v11 ="";
	String v12 ="";
	String v13 ="";
	String v14 ="";
	String v15 ="";
	String v16 ="";
	String v17 ="";
	String v18 ="";
	String v19 ="";
	String v20 ="";
	String v21 ="";
	String v22 ="";
	String v23 ="";
	String v24 ="";
	String v25 ="";
	String v26 ="";
	String v27 ="";
	String v28 ="";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	String chk_before_dt = AddUtil.getDate();
	String chk_after_dt = AddUtil.getDate();	
	int chk_current_dt = 0;
	
	chk_before_dt = c_db.addMonth(chk_before_dt, -1);
	chk_after_dt =  c_db.addMonth(chk_after_dt, 1); 
	
	chk_before_dt = AddUtil.ChangeString(chk_before_dt);
	chk_after_dt =  AddUtil.ChangeString(chk_after_dt); 
	
	for(int i=start_row ; i < value_line ; i++){
		
		flag = 0;
		count++;
		
		v1 		= value0[i]  ==null?"":value0[i];
		v2		= value1[i]  ==null?"":value1[i];
		v3		= value2[i]  ==null?"":AddUtil.replace(value2[i],"?","");
		v4		= value3[i]  ==null?"":AddUtil.replace(value3[i],"?","");
		v5		= value4[i]  ==null?"":AddUtil.replace(value4[i],"?","");
		v6		= value5[i]  ==null?"":AddUtil.replace(value5[i],"?","");
		v7		= value6[i]  ==null?"":AddUtil.replace(value6[i],"?","");
		v8		= value7[i]  ==null?"":AddUtil.replace(value7[i],"?","");
		v9		= value8[i]  ==null?"":value8[i];
		v10		= value9[i]  ==null?"":value9[i];
		v11		= value10[i] ==null?"":value10[i];
		v12		= value11[i] ==null?"":value11[i];
		v13		= value12[i] ==null?"":value12[i];
		v14		= value13[i] ==null?"":value13[i];
		v15		= value14[i] ==null?"":AddUtil.replace(value14[i],"-","");
		v16		= value15[i] ==null?"":value15[i];
		v17		= value16[i] ==null?"":AddUtil.replace(value16[i],"-","");
		v18		= value17[i] ==null?"":AddUtil.replace(value17[i],",","");
		v19		= value18[i] ==null?"":value18[i];
		v20		= value19[i] ==null?"":AddUtil.replace(value19[i],",","");
		v21		= value20[i] ==null?"":AddUtil.replace(value20[i],",","");
		v22		= value21[i] ==null?"":AddUtil.replace(value21[i],",","");
		v23		= value22[i] ==null?"":AddUtil.replace(value22[i],",","");
		v24		= value23[i] ==null?"":AddUtil.replace(value23[i],",","");
		v25		= value24[i] ==null?"":AddUtil.replace(value24[i],",","");
		v26		= value25[i] ==null?"":value25[i];
		v27		= value26[i] ==null?"":value26[i];
		v28		= value27[i] ==null?"":AddUtil.replace(value27[i],",","");
		
		/* String v14_sub = "";
		if(v14.equals("������")){
			v14_sub="������������";
		}
		if(v14.equals("����")){
			v14_sub="��������Ư��";
		}
		if(v14.equals("���ڽ�")){
			v14_sub="���ڽ�";
		}
		if(v14.equals("������")){
			v14_sub="������";
		} */
		//�ߺ��Է� üũ-----------------------------------------------------
		int over_cnt = ai_db.getCheckOverIns(v19, v18, v17, v14);
		int over_cnt2 = 0;
		chk_current_dt = AddUtil.getDate2(0) ;
		int  v17_m  = AddUtil.parseInt(v17.substring(0,6));
		
		if(chk_current_dt <= 9){ //��� ��
			if(      (  AddUtil.parseInt(chk_before_dt.substring(0,6))  <=   v17_m  )    &&     (  AddUtil.parseInt(chk_after_dt.substring(0,6))  >=   v17_m  )       ){
				
			}else{
				over_cnt2++;
			}					
		}else{ //��� ��
			if(   (  AddUtil.parseInt(AddUtil.getDate(5))  <=   v17_m  )    &&     (  AddUtil.parseInt(chk_after_dt.substring(0,6))  >=   v17_m  )      ){
			
			}else{
				over_cnt2++;
			}	
		}
		
		if(over_cnt != 0){
			out.println("<�ߺ��Է�Ȯ���ʿ�>������ȣ: "+v1+", ���ǹ�ȣ: "+v19+ ", �����׸�: " +v14 +" <br>");
		}
		if(over_cnt2 != 0){
			out.println("<�輭������ Ȯ���ʿ�>������ȣ: "+v1+", ���ǹ�ȣ: "+v19+ ", �����׸�: " +v14+", �輭������: "+v17+" <br>");
		}
		
						
		if(!v1.equals("") && !v9.equals("") && !v10.equals("") && over_cnt == 0  && over_cnt2 == 0 ){
					
			InsurExcelBean ins = new InsurExcelBean();
						
			ins.setReg_code	(reg_code);
			ins.setSeq	(count);
			ins.setReg_id	(ck_acar_id);
			ins.setGubun	("9");
			
			ins.setValue01	(v1);//1 ������ȣ
			String ch_est_dt = c_db.addMonth(v17, 1);
				ch_est_dt = ch_est_dt.substring(0,8)+"10";
			ins.setValue02	(ai_db.getValidDt(ch_est_dt));//2 ����
			ins.setValue03	(v3);//3 ��ȣ��
			ins.setValue04	(v4);//4 ����ڹ�ȣ	
			ins.setValue05	(v5);//5 �뿩������	
			
			ins.setValue06	(v6);//6 �뿩������
			ins.setValue07	(v7);//7 ����������
			ins.setValue08	(v8);//8 ����ȸ��	
			ins.setValue09	(v9);//9 ���������	
			ins.setValue10	(v10);//10 ���踸����	
			
			ins.setValue11	(v11);//11 �����ĺ���	
			ins.setValue12	(v12);//12 ������	
			ins.setValue13	(v13);//13 �̰��Խ���	
			ins.setValue14	(v14);//14 �����׸�	
			ins.setValue15	(v15);//15 ������	
			
			ins.setValue16	(v16);//16 ������
			ins.setValue17	(v17);//17 �輭������
			ins.setValue18	(v18);//18 ��¡�����
			ins.setValue19	(v19);//19 ���ǹ�ȣ
			ins.setValue20	(v20);//20 ���ι��
			
			ins.setValue21	(v21);//21 ���ι��
			ins.setValue22	(v22);//22 �빰���
			ins.setValue23	(v23);//23 �ڱ��ü���
			ins.setValue24	(v24);//24 ������������
			ins.setValue25	(v25);//25 �д����������
			
			ins.setValue26	(v26);//26 �ڱ���������
			ins.setValue27	(v27);//27 �ִ�ī	
			ins.setValue28	(v28);//28 �Ѻ����
			
			if(!ai_db.insertInsExcel2(ins))	flag += 1;
			
			//if(1==1)return;
					
		}
	}
	
	if(count >0){
		String  d_flag1 =  ai_db.call_sp_ins_excel_change(reg_code);
	}

	
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>���� ���� �о� ���� ����ϱ�
</p>

<SCRIPT LANGUAGE="JavaScript">
<!--		
		alert('����մϴ�. ����� ���躯����ȸ���� ��� Ȯ���ϼ���.');
		window.close(); 
//-->
</SCRIPT>
</BODY>
</HTML>