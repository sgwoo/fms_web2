<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*"%>
<%@ page import="acar.car_mst.*, acar.estimate_mng.*"%>
<jsp:useBean id="co_bean" class="acar.car_mst.CarOptBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>


<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//���
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//����
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//������
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//��������Ÿ�ִ����
	
	
	String result[]  = new String[value_line+10];
	String value0[]  = request.getParameterValues("value0");//����
	String value1[]  = request.getParameterValues("value1");//������
	String value2[]  = request.getParameterValues("value2");//����
	String value3[]  = request.getParameterValues("value3");//��
	String value4[]  = request.getParameterValues("value4");//�⺻����
	String value5[]  = request.getParameterValues("value5");//���ڵ�
	String value6[]  = request.getParameterValues("value6");//�Ϸù�ȣ
	String value7[]  = request.getParameterValues("value7");//����-����
	String value8[]  = request.getParameterValues("value8");//����-���ڵ�
	String value9[]  = request.getParameterValues("value9");//����-�Ϸù�ȣ
	String value10[] = request.getParameterValues("value10");//�߰��׻���
	String value11[] = request.getParameterValues("value11");//�����ڵ�
	String value12[] = request.getParameterValues("value12");//��������
	String value13[] = request.getParameterValues("value13");//��뿩��
	String value14[] = request.getParameterValues("value14");//��������
	String value15[] = request.getParameterValues("value15");//���
	String value16[] = request.getParameterValues("value16");//���û��1-��ȣ
	String value17[] = request.getParameterValues("value17");//���û��1-����
	String value18[] = request.getParameterValues("value18");//���û��1-�ݾ�
	String value19[] = request.getParameterValues("value19");//���û��2
	String value20[] = request.getParameterValues("value20");
	String value21[] = request.getParameterValues("value21");
	String value22[] = request.getParameterValues("value22");//���û��3
	String value23[] = request.getParameterValues("value23");
	String value24[] = request.getParameterValues("value24");
	String value25[] = request.getParameterValues("value25");//���û��4
	String value26[] = request.getParameterValues("value26");
	String value27[] = request.getParameterValues("value27");
	String value28[] = request.getParameterValues("value28");//���û��5
	String value29[] = request.getParameterValues("value29");
	String value30[] = request.getParameterValues("value30");
	String value31[] = request.getParameterValues("value31");//���û��6
	String value32[] = request.getParameterValues("value32");
	String value33[] = request.getParameterValues("value33");
	String value34[] = request.getParameterValues("value34");//���û��7
	String value35[] = request.getParameterValues("value35");
	String value36[] = request.getParameterValues("value36");
	String value37[] = request.getParameterValues("value37");//���û��8
	String value38[] = request.getParameterValues("value38");
	String value39[] = request.getParameterValues("value39");
	String value40[] = request.getParameterValues("value40");//���û��9
	String value41[] = request.getParameterValues("value41");
	String value42[] = request.getParameterValues("value42");
	String value43[] = request.getParameterValues("value43");//���û��10
	String value44[] = request.getParameterValues("value44");
	String value45[] = request.getParameterValues("value45");
	String value46[] = request.getParameterValues("value46");//���û��11
	String value47[] = request.getParameterValues("value47");
	String value48[] = request.getParameterValues("value48");
	String value49[] = request.getParameterValues("value49");//���û��12
	String value50[] = request.getParameterValues("value50");
	String value51[] = request.getParameterValues("value51");
	String value52[] = request.getParameterValues("value52");//���û��13
	String value53[] = request.getParameterValues("value53");
	String value54[] = request.getParameterValues("value54");
	String value55[] = request.getParameterValues("value55");//���û��14
	String value56[] = request.getParameterValues("value56");
	String value57[] = request.getParameterValues("value57");
	String value58[] = request.getParameterValues("value58");//���û��15
	String value59[] = request.getParameterValues("value59");
	String value60[] = request.getParameterValues("value60");
	String value61[] = request.getParameterValues("value61");//���û��16
	String value62[] = request.getParameterValues("value62");
	String value63[] = request.getParameterValues("value63");
	String value64[] = request.getParameterValues("value64");//���û��17
	String value65[] = request.getParameterValues("value65");
	String value66[] = request.getParameterValues("value66");
	String value67[] = request.getParameterValues("value67");//���û��18
	String value68[] = request.getParameterValues("value68");
	String value69[] = request.getParameterValues("value69");
	String value70[] = request.getParameterValues("value70");//���û��19
	String value71[] = request.getParameterValues("value71");
	String value72[] = request.getParameterValues("value72");
	String value73[] = request.getParameterValues("value73");//���û��20
	String value74[] = request.getParameterValues("value74");
	String value75[] = request.getParameterValues("value75");
	String value76[] = request.getParameterValues("value76");//���û�簹��
	String value77[] = request.getParameterValues("value77");//���û���ѱݾ�
	String value78[] = request.getParameterValues("value78");
	String value79[] = request.getParameterValues("value79");
	String value80[] = request.getParameterValues("value80");
	
	
	boolean flag = true;
	
	
	
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	
	
	for(int i=start_row ; i <= value_line ; i++){
		
		result[i] = "";
		
		String mode 			= value10[i] ==null?"":value10[i];
		String car_id			= value5[i]  ==null?"":AddUtil.replace(value5[i],"'","");
		String car_seq			= value6[i]  ==null?"":AddUtil.replace(value6[i],"'","");
		String car_name			= value3[i]  ==null?"":value3[i];
		String end_dt			= value14[i] ==null?"":AddUtil.replace(value14[i],"-","");
		
		CarMstBean cm_bean = a_cmb.getCarNmCase(car_id, car_seq);
		
		if(mode.equals("") && !end_dt.equals("") && !cm_bean.getCar_id().equals("") && cm_bean.getEnd_dt().equals("")) mode = "C";
		
		if(mode.equals("")){
			result[i] = "�������";
			continue;
		}
		
		System.out.println(car_name);
		
		String car_comp_nm		= value1[i]  ==null?"":value1[i];
		String car_nm			= value2[i]  ==null?"":value2[i];
		int    car_b_p			= value4[i]  ==null?0 :AddUtil.parseDigit(value4[i]);
		String cng_cau			= value7[i]  ==null?"":value7[i];
		String cng_car_id		= value8[i]  ==null?"":AddUtil.replace(value8[i],"'","");
		String cng_car_seq		= value9[i]  ==null?"":AddUtil.replace(value9[i],"'","");
		String jg_code			= value11[i] ==null?"":value11[i];
		String car_b_dt			= value12[i] ==null?"":AddUtil.replace(value12[i],"-","");
		String use_yn			= value13[i] ==null?"":value13[i];/*ó������ ����*/
		String opt_s_seq1		= value16[i] ==null?"":AddUtil.replace(value16[i],"'","");
		String opt_s1			= value17[i] ==null?"":AddUtil.replace(value17[i],"'","");
		int    opt_s_p1			= value18[i] ==null?0 :AddUtil.parseDigit(value18[i]);
		String opt_s_seq2		= value19[i] ==null?"":AddUtil.replace(value19[i],"'","");
		String opt_s2			= value20[i] ==null?"":AddUtil.replace(value20[i],"'","");
		int    opt_s_p2			= value21[i] ==null?0 :AddUtil.parseDigit(value21[i]);
		String opt_s_seq3		= value22[i] ==null?"":AddUtil.replace(value22[i],"'","");
		String opt_s3			= value23[i] ==null?"":AddUtil.replace(value23[i],"'","");
		int    opt_s_p3			= value24[i] ==null?0 :AddUtil.parseDigit(value24[i]);
		String opt_s_seq4		= value25[i] ==null?"":AddUtil.replace(value25[i],"'","");
		String opt_s4			= value26[i] ==null?"":AddUtil.replace(value26[i],"'","");
		int    opt_s_p4			= value27[i] ==null?0 :AddUtil.parseDigit(value27[i]);
		String opt_s_seq5		= value28[i] ==null?"":AddUtil.replace(value28[i],"'","");
		String opt_s5			= value29[i] ==null?"":AddUtil.replace(value29[i],"'","");
		int    opt_s_p5			= value30[i] ==null?0 :AddUtil.parseDigit(value30[i]);
		String opt_s_seq6		= value31[i] ==null?"":AddUtil.replace(value31[i],"'","");
		String opt_s6			= value32[i] ==null?"":AddUtil.replace(value32[i],"'","");
		int    opt_s_p6			= value33[i] ==null?0 :AddUtil.parseDigit(value33[i]);
		String opt_s_seq7		= value34[i] ==null?"":AddUtil.replace(value34[i],"'","");
		String opt_s7			= value35[i] ==null?"":AddUtil.replace(value35[i],"'","");
		int    opt_s_p7			= value36[i] ==null?0 :AddUtil.parseDigit(value36[i]);
		String opt_s_seq8		= value37[i] ==null?"":AddUtil.replace(value37[i],"'","");
		String opt_s8			= value38[i] ==null?"":AddUtil.replace(value38[i],"'","");
		int    opt_s_p8			= value39[i] ==null?0 :AddUtil.parseDigit(value39[i]);
		String opt_s_seq9		= value40[i] ==null?"":AddUtil.replace(value40[i],"'","");
		String opt_s9			= value41[i] ==null?"":AddUtil.replace(value41[i],"'","");
		int    opt_s_p9			= value42[i] ==null?0 :AddUtil.parseDigit(value42[i]);
		String opt_s_seq10		= value43[i] ==null?"":AddUtil.replace(value43[i],"'","");
		String opt_s10			= value44[i] ==null?"":AddUtil.replace(value44[i],"'","");
		int    opt_s_p10		= value45[i] ==null?0 :AddUtil.parseDigit(value45[i]);
		String opt_s_seq11		= value46[i] ==null?"":AddUtil.replace(value46[i],"'","");
		String opt_s11			= value47[i] ==null?"":AddUtil.replace(value47[i],"'","");
		int    opt_s_p11		= value48[i] ==null?0 :AddUtil.parseDigit(value48[i]);
		String opt_s_seq12		= value49[i] ==null?"":AddUtil.replace(value49[i],"'","");
		String opt_s12			= value50[i] ==null?"":AddUtil.replace(value50[i],"'","");
		int    opt_s_p12		= value51[i] ==null?0 :AddUtil.parseDigit(value51[i]);
		String opt_s_seq13		= value52[i] ==null?"":AddUtil.replace(value52[i],"'","");
		String opt_s13			= value53[i] ==null?"":AddUtil.replace(value53[i],"'","");
		int    opt_s_p13		= value54[i] ==null?0 :AddUtil.parseDigit(value54[i]);
		String opt_s_seq14		= value55[i] ==null?"":AddUtil.replace(value55[i],"'","");
		String opt_s14			= value56[i] ==null?"":AddUtil.replace(value56[i],"'","");
		int    opt_s_p14		= value57[i] ==null?0 :AddUtil.parseDigit(value57[i]);
		String opt_s_seq15		= value58[i] ==null?"":AddUtil.replace(value58[i],"'","");
		String opt_s15			= value59[i] ==null?"":AddUtil.replace(value59[i],"'","");
		int    opt_s_p15		= value60[i] ==null?0 :AddUtil.parseDigit(value60[i]);
		String opt_s_seq16		= value61[i] ==null?"":AddUtil.replace(value61[i],"'","");
		String opt_s16			= value62[i] ==null?"":AddUtil.replace(value62[i],"'","");
		int    opt_s_p16		= value63[i] ==null?0 :AddUtil.parseDigit(value63[i]);
		String opt_s_seq17		= value64[i] ==null?"":AddUtil.replace(value64[i],"'","");
		String opt_s17			= value65[i] ==null?"":AddUtil.replace(value65[i],"'","");
		int    opt_s_p17		= value66[i] ==null?0 :AddUtil.parseDigit(value66[i]);
		String opt_s_seq18		= value67[i] ==null?"":AddUtil.replace(value67[i],"'","");
		String opt_s18			= value68[i] ==null?"":AddUtil.replace(value68[i],"'","");
		int    opt_s_p18		= value69[i] ==null?0 :AddUtil.parseDigit(value69[i]);
		String opt_s_seq19		= value70[i] ==null?"":AddUtil.replace(value70[i],"'","");
		String opt_s19			= value71[i] ==null?"":AddUtil.replace(value71[i],"'","");
		int    opt_s_p19		= value72[i] ==null?0 :AddUtil.parseDigit(value72[i]);
		String opt_s_seq20		= value73[i] ==null?"":AddUtil.replace(value73[i],"'","");
		String opt_s20			= value74[i] ==null?"":AddUtil.replace(value74[i],"'","");
		int    opt_s_p20		= value75[i] ==null?0 :AddUtil.parseDigit(value75[i]);
		
		
		out.println(mode				+"&nbsp;&nbsp;&nbsp;");
		out.println(car_id				+"&nbsp;&nbsp;&nbsp;");
		out.println(car_seq				+"&nbsp;&nbsp;&nbsp;");
		out.println(cng_car_id			+"&nbsp;&nbsp;&nbsp;");
		out.println(cm_bean.getCar_nm()	+"&nbsp;&nbsp;&nbsp;");
		out.println(car_nm	);
		out.println("<br>");
		
		
		int count = 0;
		
		
		if(mode.equals("C") && cm_bean.getCar_id().equals("")){
			mode = "I";
		}
		
		
		if(mode.equals("i")||mode.equals("I")){//---------------------------------------------------------------------------------------------------
			
			if(car_id.equals("")){
				//���� ���
				
				result[i] = "�űԵ��";
				
				String car_comp_id	= a_cmb.getCarCompCd(car_comp_nm, car_nm);
				String car_cd		= a_cmb.getCarNmCd(car_comp_nm, car_nm);
				
								
				cm_bean = new CarMstBean();
				
				cm_bean.setCar_comp_id		(car_comp_id);
				cm_bean.setCar_cd		(car_cd);
				cm_bean.setCar_name		(car_name);
				cm_bean.setCar_b_p		(car_b_p);
				cm_bean.setCar_b_dt		(car_b_dt);
				cm_bean.setJg_code		(jg_code);
				cm_bean.setEnd_dt		(end_dt);
//				cm_bean.setCar_yn		("Y");


				//�ܰ�����NEW
				ej_bean = e_db.getEstiJgVarCase(jg_code, "");
				
				if(ej_bean.getJg_b().equals("1")) 			cm_bean.setDiesel_yn("Y");
				else if(ej_bean.getJg_b().equals("2")) 		cm_bean.setDiesel_yn("2");
				else if(ej_bean.getJg_b().equals("3")) 		cm_bean.setDiesel_yn("3");//���̺긮��
				else if(ej_bean.getJg_b().equals("4")) 		cm_bean.setDiesel_yn("4");//�÷������̺긮��
				else if(ej_bean.getJg_b().equals("5")) 		cm_bean.setDiesel_yn("5");//������				
				else if(ej_bean.getJg_b().equals("6")) 		cm_bean.setDiesel_yn("6");//������	
				else if(ej_bean.getJg_b().equals("0")) 		cm_bean.setDiesel_yn("1");//�ֹ���
				else              							cm_bean.setDiesel_yn("1");
	
				cm_bean.setS_st			(ej_bean.getJg_a());
				cm_bean.setSection		(ej_bean.getJg_r());	
				cm_bean.setDpm			(ej_bean.getJg_c());
				
				
				car_id = a_cmb.insertCarNm(cm_bean);
				
				//��������
				CarMstBean cm_bean2 = a_cmb.getCarNmCase(car_id, "");
				
				
				//1. ���û�纯��--------------------------------------------
				
				if(!opt_s1.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s1);
					co_bean.setCar_s_p		(opt_s_p1);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s2.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s2);
					co_bean.setCar_s_p		(opt_s_p2);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s3.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s3);
					co_bean.setCar_s_p		(opt_s_p3);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s4.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s4);
					co_bean.setCar_s_p		(opt_s_p4);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s5.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s5);
					co_bean.setCar_s_p		(opt_s_p5);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s6.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s6);
					co_bean.setCar_s_p		(opt_s_p6);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s7.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s7);
					co_bean.setCar_s_p		(opt_s_p7);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s8.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s8);
					co_bean.setCar_s_p		(opt_s_p8);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s9.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s9);
					co_bean.setCar_s_p		(opt_s_p9);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s10.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s10);
					co_bean.setCar_s_p		(opt_s_p10);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s11.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s11);
					co_bean.setCar_s_p		(opt_s_p11);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s12.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s12);
					co_bean.setCar_s_p		(opt_s_p12);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s13.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s13);
					co_bean.setCar_s_p		(opt_s_p13);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s14.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s14);
					co_bean.setCar_s_p		(opt_s_p14);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s15.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s15);
					co_bean.setCar_s_p		(opt_s_p15);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s16.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s16);
					co_bean.setCar_s_p		(opt_s_p16);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s17.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s17);
					co_bean.setCar_s_p		(opt_s_p17);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s18.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s18);
					co_bean.setCar_s_p		(opt_s_p18);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s19.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s19);
					co_bean.setCar_s_p		(opt_s_p19);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s20.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s20);
					co_bean.setCar_s_p		(opt_s_p20);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
			}else{
				//���׷��̵� ���
				
				result[i] = "���׷��̵���";
				
				//��������
				CarMstBean cm_bean3 = a_cmb.getCarNmCase2(car_id, "", car_b_dt);
				
				if(!cm_bean3.getCar_id().equals("")) cm_bean = cm_bean3;
				
				cm_bean.setCar_cd		(cm_bean.getCode());
				cm_bean.setCar_name		(car_name);
				cm_bean.setCar_b_p		(car_b_p);
				cm_bean.setCar_b_dt		(car_b_dt);
				cm_bean.setJg_code		(jg_code);
				cm_bean.setEnd_dt		(end_dt);
//				cm_bean.setCar_yn		(use_yn);

				//�ܰ�����NEW
				ej_bean = e_db.getEstiJgVarCase(jg_code, "");
				
				if(ej_bean.getJg_b().equals("1")) 			cm_bean.setDiesel_yn("Y");
				else if(ej_bean.getJg_b().equals("2")) 		cm_bean.setDiesel_yn("2");
				else if(ej_bean.getJg_b().equals("3")) 		cm_bean.setDiesel_yn("3");//���̺긮��
				else if(ej_bean.getJg_b().equals("4")) 		cm_bean.setDiesel_yn("4");//�÷������̺긮��
				else if(ej_bean.getJg_b().equals("5")) 		cm_bean.setDiesel_yn("5");//������				
				else if(ej_bean.getJg_b().equals("6")) 		cm_bean.setDiesel_yn("6");//������	
				else if(ej_bean.getJg_b().equals("0")) 		cm_bean.setDiesel_yn("1");//�ֹ���
				else              							cm_bean.setDiesel_yn("1");
	
				cm_bean.setS_st			(ej_bean.getJg_a());
				cm_bean.setSection		(ej_bean.getJg_r());	
				cm_bean.setDpm			(ej_bean.getJg_c());
				
				car_id = a_cmb.insertCarNm(cm_bean);
				
				//��������
				CarMstBean cm_bean2 = a_cmb.getCarNmCase(car_id, "");
				
				
				//1. ���û�纯��--------------------------------------------
				
				if(!opt_s1.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s1);
					co_bean.setCar_s_p		(opt_s_p1);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s2.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s2);
					co_bean.setCar_s_p		(opt_s_p2);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s3.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s3);
					co_bean.setCar_s_p		(opt_s_p3);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s4.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s4);
					co_bean.setCar_s_p		(opt_s_p4);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s5.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s5);
					co_bean.setCar_s_p		(opt_s_p5);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s6.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s6);
					co_bean.setCar_s_p		(opt_s_p6);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s7.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s7);
					co_bean.setCar_s_p		(opt_s_p7);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s8.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s8);
					co_bean.setCar_s_p		(opt_s_p8);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s9.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s9);
					co_bean.setCar_s_p		(opt_s_p9);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s10.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s10);
					co_bean.setCar_s_p		(opt_s_p10);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s11.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s11);
					co_bean.setCar_s_p		(opt_s_p11);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s12.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s12);
					co_bean.setCar_s_p		(opt_s_p12);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s13.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s13);
					co_bean.setCar_s_p		(opt_s_p13);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s14.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s14);
					co_bean.setCar_s_p		(opt_s_p14);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s15.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s15);
					co_bean.setCar_s_p		(opt_s_p15);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s16.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s16);
					co_bean.setCar_s_p		(opt_s_p16);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s17.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s17);
					co_bean.setCar_s_p		(opt_s_p17);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s18.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s18);
					co_bean.setCar_s_p		(opt_s_p18);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s19.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s19);
					co_bean.setCar_s_p		(opt_s_p19);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
				if(!opt_s20.equals("")){
					co_bean = new CarOptBean();
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(cm_bean2.getCar_seq());
					co_bean.setUse_yn		("Y");
					co_bean.setCar_s		(opt_s20);
					co_bean.setCar_s_p		(opt_s_p20);
					co_bean.setCar_s_dt		(car_b_dt);
					count = a_cmb.insertCarOpt(co_bean);
				}
				
			}
		}else if(mode.equals("c")||mode.equals("C")){//---------------------------------------------------------------------------------------------------
			
			cm_bean.setCar_cd		(cm_bean.getCode());
			
				//1. ���û�纯��--------------------------------------------
				
				co_bean = a_cmb.getCarOptCase(cm_bean.getCar_comp_id(), cm_bean.getCar_cd(), car_id, car_seq, opt_s_seq1);
				co_bean.setCar_s			(opt_s1);
				co_bean.setCar_s_p			(opt_s_p1);
				co_bean.setCar_s_dt			(car_b_dt);
				if(co_bean.getCar_s_seq().equals("")){
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(car_seq);
					co_bean.setUse_yn		("Y");
					if(!opt_s1.equals(""))	count = a_cmb.insertCarOpt(co_bean);
				}else{
					if(!opt_s1.equals(""))	count = a_cmb.updateCarOpt(co_bean);
					else 					count = a_cmb.deleteCarOpt(co_bean);
				}
				
				co_bean = a_cmb.getCarOptCase(cm_bean.getCar_comp_id(), cm_bean.getCar_cd(), car_id, car_seq, opt_s_seq2);
				co_bean.setCar_s			(opt_s2);
				co_bean.setCar_s_p			(opt_s_p2);
				co_bean.setCar_s_dt			(car_b_dt);
				if(co_bean.getCar_s_seq().equals("")){
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(car_seq);
					co_bean.setUse_yn		("Y");
					if(!opt_s2.equals(""))	count = a_cmb.insertCarOpt(co_bean);
				}else{
					if(!opt_s2.equals(""))	count = a_cmb.updateCarOpt(co_bean);
					else					count = a_cmb.deleteCarOpt(co_bean);
				}
				
				co_bean = a_cmb.getCarOptCase(cm_bean.getCar_comp_id(), cm_bean.getCar_cd(), car_id, car_seq, opt_s_seq3);
				co_bean.setCar_s			(opt_s3);
				co_bean.setCar_s_p			(opt_s_p3);
				co_bean.setCar_s_dt			(car_b_dt);
				if(co_bean.getCar_s_seq().equals("")){
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(car_seq);
					co_bean.setUse_yn		("Y");
					if(!opt_s3.equals(""))	count = a_cmb.insertCarOpt(co_bean);
				}else{
					if(!opt_s3.equals(""))	count = a_cmb.updateCarOpt(co_bean);
					else					count = a_cmb.deleteCarOpt(co_bean);
				}
				
				co_bean = a_cmb.getCarOptCase(cm_bean.getCar_comp_id(), cm_bean.getCar_cd(), car_id, car_seq, opt_s_seq4);
				co_bean.setCar_s			(opt_s4);
				co_bean.setCar_s_p			(opt_s_p4);
				co_bean.setCar_s_dt			(car_b_dt);
				if(co_bean.getCar_s_seq().equals("")){
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(car_seq);
					co_bean.setUse_yn		("Y");
					if(!opt_s4.equals(""))	count = a_cmb.insertCarOpt(co_bean);
				}else{
					if(!opt_s4.equals(""))	count = a_cmb.updateCarOpt(co_bean);
					else					count = a_cmb.deleteCarOpt(co_bean);
				}
				
				co_bean = a_cmb.getCarOptCase(cm_bean.getCar_comp_id(), cm_bean.getCar_cd(), car_id, car_seq, opt_s_seq5);
				co_bean.setCar_s			(opt_s5);
				co_bean.setCar_s_p			(opt_s_p5);
				co_bean.setCar_s_dt			(car_b_dt);
				if(co_bean.getCar_s_seq().equals("")){
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(car_seq);
					co_bean.setUse_yn		("Y");
					if(!opt_s5.equals(""))	count = a_cmb.insertCarOpt(co_bean);
				}else{
					if(!opt_s5.equals(""))	count = a_cmb.updateCarOpt(co_bean);
					else					count = a_cmb.deleteCarOpt(co_bean);
				}
				
				co_bean = a_cmb.getCarOptCase(cm_bean.getCar_comp_id(), cm_bean.getCar_cd(), car_id, car_seq, opt_s_seq6);
				co_bean.setCar_s			(opt_s6);
				co_bean.setCar_s_p			(opt_s_p6);
				co_bean.setCar_s_dt			(car_b_dt);
				if(co_bean.getCar_s_seq().equals("")){
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(car_seq);
					co_bean.setUse_yn		("Y");
					if(!opt_s6.equals(""))	count = a_cmb.insertCarOpt(co_bean);
				}else{
					if(!opt_s6.equals(""))	count = a_cmb.updateCarOpt(co_bean);
					else					count = a_cmb.deleteCarOpt(co_bean);
				}
				
				co_bean = a_cmb.getCarOptCase(cm_bean.getCar_comp_id(), cm_bean.getCar_cd(), car_id, car_seq, opt_s_seq7);
				co_bean.setCar_s			(opt_s7);
				co_bean.setCar_s_p			(opt_s_p7);
				co_bean.setCar_s_dt			(car_b_dt);
				if(co_bean.getCar_s_seq().equals("")){
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(car_seq);
					co_bean.setUse_yn		("Y");
					if(!opt_s7.equals(""))	count = a_cmb.insertCarOpt(co_bean);
				}else{
					if(!opt_s7.equals(""))	count = a_cmb.updateCarOpt(co_bean);
					else					count = a_cmb.deleteCarOpt(co_bean);
				}
				
				co_bean = a_cmb.getCarOptCase(cm_bean.getCar_comp_id(), cm_bean.getCar_cd(), car_id, car_seq, opt_s_seq8);
				co_bean.setCar_s			(opt_s8);
				co_bean.setCar_s_p			(opt_s_p8);
				co_bean.setCar_s_dt			(car_b_dt);
				if(co_bean.getCar_s_seq().equals("")){
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(car_seq);
					co_bean.setUse_yn		("Y");
					if(!opt_s8.equals(""))	count = a_cmb.insertCarOpt(co_bean);
				}else{
					if(!opt_s8.equals(""))	count = a_cmb.updateCarOpt(co_bean);
					else					count = a_cmb.deleteCarOpt(co_bean);
				}
				
				co_bean = a_cmb.getCarOptCase(cm_bean.getCar_comp_id(), cm_bean.getCar_cd(), car_id, car_seq, opt_s_seq9);
				co_bean.setCar_s			(opt_s9);
				co_bean.setCar_s_p			(opt_s_p9);
				co_bean.setCar_s_dt			(car_b_dt);
				if(co_bean.getCar_s_seq().equals("")){
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(car_seq);
					co_bean.setUse_yn		("Y");
					if(!opt_s9.equals(""))	count = a_cmb.insertCarOpt(co_bean);
				}else{
					if(!opt_s9.equals(""))	count = a_cmb.updateCarOpt(co_bean);
					else					count = a_cmb.deleteCarOpt(co_bean);
				}
				
				co_bean = a_cmb.getCarOptCase(cm_bean.getCar_comp_id(), cm_bean.getCar_cd(), car_id, car_seq, opt_s_seq10);
				co_bean.setCar_s			(opt_s10);
				co_bean.setCar_s_p			(opt_s_p10);
				co_bean.setCar_s_dt			(car_b_dt);
				if(co_bean.getCar_s_seq().equals("")){
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(car_seq);
					co_bean.setUse_yn		("Y");
					if(!opt_s10.equals(""))	count = a_cmb.insertCarOpt(co_bean);
				}else{
					if(!opt_s10.equals(""))	count = a_cmb.updateCarOpt(co_bean);
					else					count = a_cmb.deleteCarOpt(co_bean);
				}
				
				co_bean = a_cmb.getCarOptCase(cm_bean.getCar_comp_id(), cm_bean.getCar_cd(), car_id, car_seq, opt_s_seq11);
				co_bean.setCar_s			(opt_s11);
				co_bean.setCar_s_p			(opt_s_p11);
				co_bean.setCar_s_dt			(car_b_dt);
				if(co_bean.getCar_s_seq().equals("")){
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(car_seq);
					co_bean.setUse_yn		("Y");
					if(!opt_s11.equals(""))	count = a_cmb.insertCarOpt(co_bean);
				}else{
					if(!opt_s11.equals(""))	count = a_cmb.updateCarOpt(co_bean);
					else					count = a_cmb.deleteCarOpt(co_bean);
				}
				
				co_bean = a_cmb.getCarOptCase(cm_bean.getCar_comp_id(), cm_bean.getCar_cd(), car_id, car_seq, opt_s_seq12);
				co_bean.setCar_s			(opt_s12);
				co_bean.setCar_s_p			(opt_s_p12);
				co_bean.setCar_s_dt			(car_b_dt);
				if(co_bean.getCar_s_seq().equals("")){
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(car_seq);
					co_bean.setUse_yn		("Y");
					if(!opt_s12.equals(""))	count = a_cmb.insertCarOpt(co_bean);
				}else{
					if(!opt_s12.equals(""))	count = a_cmb.updateCarOpt(co_bean);
					else					count = a_cmb.deleteCarOpt(co_bean);
				}
				
				co_bean = a_cmb.getCarOptCase(cm_bean.getCar_comp_id(), cm_bean.getCar_cd(), car_id, car_seq, opt_s_seq13);
				co_bean.setCar_s			(opt_s13);
				co_bean.setCar_s_p			(opt_s_p13);
				co_bean.setCar_s_dt			(car_b_dt);
				if(co_bean.getCar_s_seq().equals("")){
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(car_seq);
					co_bean.setUse_yn		("Y");
					if(!opt_s13.equals(""))	count = a_cmb.insertCarOpt(co_bean);
				}else{
					if(!opt_s13.equals(""))	count = a_cmb.updateCarOpt(co_bean);
					else					count = a_cmb.deleteCarOpt(co_bean);
				}
				
				co_bean = a_cmb.getCarOptCase(cm_bean.getCar_comp_id(), cm_bean.getCar_cd(), car_id, car_seq, opt_s_seq14);
				co_bean.setCar_s			(opt_s14);
				co_bean.setCar_s_p			(opt_s_p14);
				co_bean.setCar_s_dt			(car_b_dt);
				if(co_bean.getCar_s_seq().equals("")){
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(car_seq);
					co_bean.setUse_yn		("Y");
					if(!opt_s14.equals(""))	count = a_cmb.insertCarOpt(co_bean);
				}else{
					if(!opt_s14.equals(""))	count = a_cmb.updateCarOpt(co_bean);
					else					count = a_cmb.deleteCarOpt(co_bean);
				}
				
				co_bean = a_cmb.getCarOptCase(cm_bean.getCar_comp_id(), cm_bean.getCar_cd(), car_id, car_seq, opt_s_seq15);
				co_bean.setCar_s			(opt_s15);
				co_bean.setCar_s_p			(opt_s_p15);
				co_bean.setCar_s_dt			(car_b_dt);
				if(co_bean.getCar_s_seq().equals("")){
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(car_seq);
					co_bean.setUse_yn		("Y");
					if(!opt_s15.equals(""))	count = a_cmb.insertCarOpt(co_bean);
				}else{
					if(!opt_s15.equals(""))	count = a_cmb.updateCarOpt(co_bean);
					else					count = a_cmb.deleteCarOpt(co_bean);
				}
				
				co_bean = a_cmb.getCarOptCase(cm_bean.getCar_comp_id(), cm_bean.getCar_cd(), car_id, car_seq, opt_s_seq16);
				co_bean.setCar_s			(opt_s16);
				co_bean.setCar_s_p			(opt_s_p16);
				co_bean.setCar_s_dt			(car_b_dt);
				if(co_bean.getCar_s_seq().equals("")){
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(car_seq);
					co_bean.setUse_yn		("Y");
					if(!opt_s16.equals(""))	count = a_cmb.insertCarOpt(co_bean);
				}else{
					if(!opt_s16.equals(""))	count = a_cmb.updateCarOpt(co_bean);
					else					count = a_cmb.deleteCarOpt(co_bean);
				}
				
				co_bean = a_cmb.getCarOptCase(cm_bean.getCar_comp_id(), cm_bean.getCar_cd(), car_id, car_seq, opt_s_seq17);
				co_bean.setCar_s			(opt_s17);
				co_bean.setCar_s_p			(opt_s_p17);
				co_bean.setCar_s_dt			(car_b_dt);
				if(co_bean.getCar_s_seq().equals("")){
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(car_seq);
					co_bean.setUse_yn		("Y");
					if(!opt_s17.equals(""))	count = a_cmb.insertCarOpt(co_bean);
				}else{
					if(!opt_s17.equals(""))	count = a_cmb.updateCarOpt(co_bean);
					else					count = a_cmb.deleteCarOpt(co_bean);
				}
				
				co_bean = a_cmb.getCarOptCase(cm_bean.getCar_comp_id(), cm_bean.getCar_cd(), car_id, car_seq, opt_s_seq18);
				co_bean.setCar_s			(opt_s18);
				co_bean.setCar_s_p			(opt_s_p18);
				co_bean.setCar_s_dt			(car_b_dt);
				if(co_bean.getCar_s_seq().equals("")){
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(car_seq);
					co_bean.setUse_yn		("Y");
					if(!opt_s18.equals(""))	count = a_cmb.insertCarOpt(co_bean);
				}else{
					if(!opt_s18.equals(""))	count = a_cmb.updateCarOpt(co_bean);
					else					count = a_cmb.deleteCarOpt(co_bean);
				}
				
				co_bean = a_cmb.getCarOptCase(cm_bean.getCar_comp_id(), cm_bean.getCar_cd(), car_id, car_seq, opt_s_seq19);
				co_bean.setCar_s			(opt_s19);
				co_bean.setCar_s_p			(opt_s_p19);
					co_bean.setCar_s_dt			(car_b_dt);
				if(co_bean.getCar_s_seq().equals("")){
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(car_seq);
					co_bean.setUse_yn		("Y");
					if(!opt_s19.equals(""))	count = a_cmb.insertCarOpt(co_bean);
				}else{
					if(!opt_s19.equals(""))	count = a_cmb.updateCarOpt(co_bean);
					else					count = a_cmb.deleteCarOpt(co_bean);
				}
				
				co_bean = a_cmb.getCarOptCase(cm_bean.getCar_comp_id(), cm_bean.getCar_cd(), car_id, car_seq, opt_s_seq20);
				co_bean.setCar_s			(opt_s20);
				co_bean.setCar_s_p			(opt_s_p20);
				co_bean.setCar_s_dt			(car_b_dt);
				if(co_bean.getCar_s_seq().equals("")){
					co_bean.setCar_comp_id		(cm_bean.getCar_comp_id());
					co_bean.setCar_cd		(cm_bean.getCar_cd());
					co_bean.setCar_id		(car_id);
					co_bean.setCar_u_seq		(car_seq);
					co_bean.setUse_yn		("Y");
					if(!opt_s20.equals(""))	count = a_cmb.insertCarOpt(co_bean);
				}else{
					if(!opt_s20.equals(""))	count = a_cmb.updateCarOpt(co_bean);
					else					count = a_cmb.deleteCarOpt(co_bean);
				}
			
			
				//����� �����ڵ� ��������--------------------------------------------------------------------------------------------
				String cng_car_cd = "";
				if(!cm_bean.getCar_nm().equals(car_nm)){
					cng_car_cd = a_cmb.getCarNmCd(car_comp_nm, car_nm);
				}
				
				cm_bean.setCar_name		(car_name);
				cm_bean.setCar_b_p		(car_b_p);
				cm_bean.setCar_b_dt		(car_b_dt);
				cm_bean.setJg_code		(jg_code);
				cm_bean.setEnd_dt		(end_dt);
//				cm_bean.setCar_yn		(use_yn);
				
				if(cng_car_id.equals("�ű��ڵ�")){
					cng_car_id = a_cmb.getCarNmId();
				}
				
				count = a_cmb.updateCarNm2(cm_bean, cng_car_cd, cng_car_id);
				
				result[i] = "����ó��";
				
				if(!cng_car_cd.equals("") || !cng_car_id.equals("")){
					
					//��������
					CarMstBean cm_bean2 = a_cmb.getCarNmCase(cng_car_id, "");
					
					//�����ڵ� ���û�� �ϰ� ����
					count = a_cmb.updateCarOpt2(cm_bean, cm_bean2, cng_car_cd, cng_car_id);
					
					if(!cng_car_id.equals("") && !cm_bean.getCar_id().equals(cng_car_id)){
						//�����ڵ� ������� �ϰ� ����
						count = a_cmb.updateCarEctCd(cm_bean, cm_bean2, cng_car_cd, cng_car_id);
					}
					
					result[i] = "�ڵ庯�� ����ó��";
				}
			
		}else if(mode.equals("d")||mode.equals("D")){//---------------------------------------------------------------------------------------------------
			
			cm_bean.setCar_cd		(cm_bean.getCode());
			cm_bean.setCar_b_dt		("19990101");
			cm_bean.setEnd_dt		("19991231");
			cm_bean.setCar_yn		("N");
			count = a_cmb.updateCarNm(cm_bean);
			
			result[i] = "����ó��";
		}
		
		
	}
	int result_cnt = 0;
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
<form action="excel_result.jsp" method='post' name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
</form>
<table>
  <tr>
    <td>����</td>
    <td>������ȣ</td>	
    <td>���</td>		
  </tr>
<%	for(int i=start_row ; i < value_line ; i++){
		if(result[i].equals("�������.")) continue;
		result_cnt++;%>  
  <tr>
    <td><%=value0[i]%></td>
    <td><%=value2[i]%></td>	
    <td><%=result[i]%></td>		
  </tr>		
<%	}%>		
</table>
<SCRIPT LANGUAGE="JavaScript">
<!--		
		//document.form1.submit();			
//-->
</SCRIPT>
</BODY>
</HTML>