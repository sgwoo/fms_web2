<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.estimate_mng.*, acar.account.*"%>
<jsp:useBean id="st_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript' src='/include/estimate.js'></script>
<script language='javascript'>
<!--
	//���� ������ ����Ʈ �̵�
	function list_move(bus_id2)
	{
		var fm = document.form1;
		var url = "";
		fm.gubun1.value = '7';
		fm.gubun2.value = '2';
		fm.gubun3.value = '3';	
		fm.gubun4.value = '';			
		fm.s_kd.value = '8';		
		fm.t_wd.value = bus_id2;			
		url = "/acar/settle_acc/settle_s_frame.jsp";
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
//-->
</script>
</head>

<body>
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String search_kd = request.getParameter("search_kd")==null?"":request.getParameter("search_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String dept_id = request.getParameter("dept_id")==null?"0002":request.getParameter("dept_id");	
	String bus_id2 = request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	float dly_per1 = 0;
	float dly_per2 = 0;
	float per_0405 = 0;
	String per2 = "";
	float sum_tot_amt1 = 0, sum_tot_amt2 = 0 ;
	float a_per1 = 0;
	float a_avg_per = 0;
	float a_cmp_per = 0;
	float a_eff_per = 0;
	int cnt = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//���� ����
	String var1 = e_db.getEstiSikVarCase("1", "", "dly1");
	String var2 = e_db.getEstiSikVarCase("1", "", "dly2");
	
	
	String var3 = e_db.getEstiSikVarCase("1", "", "dly1_bus3");
	String var4 = e_db.getEstiSikVarCase("1", "", "dly1_bus4");
	String var5 = e_db.getEstiSikVarCase("1", "", "dly1_bus5");
	String var6 = e_db.getEstiSikVarCase("1", "", "dly1_bus6");
	String var7 = e_db.getEstiSikVarCase("1", "", "dly1_bus7");
	String var12 = e_db.getEstiSikVarCase("1", "", "dly1_bus12");
	
	
	//��ü�� �׷���
	Vector feedps = st_db.getStatSettle("1", save_dt, var12, var7);
	int feedp_size = feedps.size();	
	
	int sum_tot_amt6 = 0, sum_tot_amt7 = 0 ;
	int sum_tot_amt3 = 0, sum_tot_amt4 = 0 ;
	

%>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='dept_id' value='<%=dept_id%>'>
<input type='hidden' name='size' value='<%=feedp_size%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='gubun1' value=''>
<input type='hidden' name='gubun2' value=''>
<input type='hidden' name='gubun3' value=''>
<input type='hidden' name='gubun4' value='1'>
<input type='hidden' name='s_kd' value=''>
<input type='hidden' name='t_wd' value=''>
<input type='hidden' name='size2' value=''>
<input type='hidden' name='max_i' value=''>

<table width="900" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�濵���� > ķ���ΰ��� > <span class=style5>ä�ǰ���ķ����(1��)</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>

    <tr> 
        <td class="line">          
            <TABLE align=center border=0 width=100% cellspacing=1 cellpadding=0>
                <tr> 
                    <td colspan="2" class="title">�����</TD>
                    <td class="title">���Ͽ�ü��</TD>
                    <td class="title">��տ�ü��</TD>
                    <td class="title">���뿬ü��</TD>					
                    <td>
                      <table width=100% border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td class="title_p" style='text-align:right' width="100">1</td>
                          <td class="title_p" style='text-align:right' width="100">2</td>
                          <td class="title_p" style='text-align:right' width="100">3</td>
                          <td class="title_p" style='text-align:right' width="100">4</td>                          
                        </tr>
                      </table>
                    </TD>
                    <td colspan="2" class="title">����ں� ���ʽ�</td>
                </tr>
			
          <%if(feedp_size > 0){
				String tot_dly_amt = "0";
				if(save_dt.equals("")){
					tot_dly_amt = st_db.getStatSettleAmt("d");//���Ͽ�ü�Ѿ�
				}	
				for (int i = 0 ; i < feedp_size ; i++){
					IncomingSBean feedp = (IncomingSBean)feedps.elementAt(i);
					
					if(feedp.getTot_su6().equals("")) feedp.setTot_su7(feedp.getTot_su3());
					
					dly_per1 = Float.parseFloat(feedp.getTot_su7())*100;
					
					if(feedp.getTot_su4().equals("")){
						dly_per2 = Float.parseFloat(feedp.getTot_amt2())/Float.parseFloat(tot_dly_amt)*100;
						per2 = (dly_per2==0)?"0.0":Float.toString(dly_per2).substring(0,Float.toString(dly_per2).indexOf(".")+3);
					}else{
						per2 = feedp.getTot_su4();
					}
					//�׷��� �ִ���� 400
					if(dly_per1 > 400) dly_per1=400;
					//�ӿ�����
					if(feedp.getGubun().equals("000003") || feedp.getGubun().equals("000004") || feedp.getGubun().equals("000005")){
						cnt = cnt+1;
						continue;
					}
					//�հ�
					sum_tot_amt1 += Float.parseFloat(feedp.getTot_amt1());
					sum_tot_amt2 += Float.parseFloat(feedp.getTot_amt2());
					sum_tot_amt6 += AddUtil.parseInt(feedp.getTot_amt6());
					sum_tot_amt7 += AddUtil.parseInt(feedp.getTot_amt7());
					
					sum_tot_amt3 += AddUtil.parseInt(feedp.getTot_amt4());
					sum_tot_amt4 += AddUtil.parseInt(feedp.getTot_amt5());
					
					//���
					a_per1 		+= Float.parseFloat(feedp.getTot_su3()==null?"0":feedp.getTot_su3());
					a_avg_per 	+= Float.parseFloat(feedp.getTot_su6()==null?"0":feedp.getTot_su6());
					a_cmp_per 	+= Float.parseFloat(feedp.getTot_su7()==null?"0":feedp.getTot_su7());
					a_eff_per 		+= Float.parseFloat(feedp.getTot_su9()==null?"0":feedp.getTot_su9());
					
					//if(feedp.getBr_id().equals("S1")) feedp.setPartner_nm("");
			%>
                <TR> 
                    <TD width="58" style='background-color:e2fff8' align=center><a href="javascript:list_move('<%=feedp.getGubun()%>');"><%=c_db.getNameById(feedp.getGubun(), "USER")%></a> 
                      <input type='hidden' name='dept_id' value='<%=feedp.getDept_id()%>'>
        			  <input type='hidden' name='brch_id' value='<%=feedp.getBr_id()%>'></TD>
                    <TD width="57" style='background-color:e2fff8' align=center><%=feedp.getPartner_nm()%></TD>
                    <TD align="center" width="75"><input type="text" name="per1" value="<%=AddUtil.parseFloatCipher(feedp.getTot_su3(),3)%>" size="4" class="whitenum">
                      %</TD>
                    <TD align="center" width="75"><input type="text" name="avg_per" value="<%=AddUtil.parseFloatCipher(feedp.getTot_su6(),3)%>" size="4" class="whitenum">
                      %</TD>
                    <TD align="center" width="75"><input type="text" name="cmp_per" value="<%=AddUtil.parseFloatCipher(feedp.getTot_su7(),3)%>" size="4" class="whitenum">
                      %</TD>
                    <TD width="402">
                  <!--  <img src=../../images/result1.gif width=<%=Float.toString(dly_per1).substring(0,Float.toString(dly_per1).indexOf("."))%> height=10> -->
                    <img src=../../images/result1.gif width=<%=dly_per1*4%>% height=10>
                    <%if(AddUtil.parseInt(feedp.getTot_su5())>100){%>&nbsp;&nbsp;������������:<%}%><input type="text" name="cont" value="<%=feedp.getTot_su5()%>" size="3" class="whitenum"><%if(AddUtil.parseInt(feedp.getTot_su5())>100){%>%<%}%>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="eff_per" value="<%=AddUtil.parseFloatCipher(feedp.getTot_su9(),3)%>" size="6" class="whitenum">                   
                    </TD>
                    <TD align="right" width="79"><input type="text" name="b_amt_out" value="<%= AddUtil.parseDecimal(feedp.getTot_amt4()) %>" size="10" class="whitenum">
                      <%if(AddUtil.parseInt(feedp.getTot_amt6())>0){%><br><font color='red'><%= AddUtil.parseDecimal(feedp.getTot_amt6()) %></font><%}%>
                      </TD>
                    <TD align="right" width="79"><input type="text" name="b_amt_in" value="<%= AddUtil.parseDecimal(feedp.getTot_amt5()) %>" size="9" class="whitenum">
                      <%if(AddUtil.parseInt(feedp.getTot_amt7())>0){%><br><font color='red'><%= AddUtil.parseDecimal(feedp.getTot_amt7()) %></font><%}%>
                    </TD>
                </TR>
        		  <input type='hidden' name='tot_fee_amt' value='<%=feedp.getTot_amt1()%>'>
        		  <input type='hidden' name='bus_nm' value='<%=c_db.getNameById(feedp.getGubun(), "USER")%>'>
        		  <input type='hidden' name='per_0405' value='<%=AddUtil.parseFloatCipher(feedp.getTot_su5(),2)%>'>
        		  <input type='hidden' name='per_cha' value=''>
        		  <input type='hidden' name='partner_id' value='<%=feedp.getPartner_id()%>'>
        		  <input type='hidden' name='bus_id2' value='<%=feedp.getGubun()%>'>
                  <%	}%>
                <TR> 
                    <TD colspan="2" class="title">���</TD>
                    <TD class="title"><input type="text" name="a_per1" value="" size="4" class="whitenum">
%</TD>
                    <TD class="title"><input type="text" name="a_avg_per" value="" size="4" class="whitenum">
%</TD>
                    <TD class="title"><input type="text" name="a_cmp_per" value="" size="4" class="whitenum">
%</TD>
                    <TD class="title" style='text-align:right'>�հ� : <%= AddUtil.parseDecimal(sum_tot_amt3+sum_tot_amt4) %></TD>
                    <TD class="title" style='text-align:right'><%= AddUtil.parseDecimal(sum_tot_amt3) %></TD>
                    <TD  class="title" style='text-align:right'><%= AddUtil.parseDecimal(sum_tot_amt4) %></TD>
                </TR>
                
                <TR> 
                    <TD colspan="2" class="title">��»�</TD>
                    <TD class="title"></TD>
                    <TD class="title"></TD>
                    <TD class="title"><input type="text" name="a_eff_per" value="" size="8" class="whitenum"></TD>
                    <TD class="title" style='text-align:right'>�հ� :
                      <%= AddUtil.parseDecimal(sum_tot_amt6+sum_tot_amt7) %>��</TD>
                    <TD class="title" style='text-align:right'><%= AddUtil.parseDecimal(sum_tot_amt6) %>��</TD>
                    <TD class="title" style='text-align:right'><%= AddUtil.parseDecimal(sum_tot_amt7) %>��</TD>
                </TR>                
            
          <%	}else{%>
                <TR align="center"> 
                    <TD colspan="8">��ϵ� �ڷᰡ �����ϴ�.</TD>
                </TR>
          <%}%>
            </TABLE>
        </td>
    </tr>
</table>
</form>
<script language='javascript'>
<!--

	
document.form1.a_per1.value 	          = '<%= AddUtil.parseFloatCipher2(a_per1/feedp_size, 3) %>';
document.form1.a_avg_per.value 	 = '<%= AddUtil.parseFloatCipher2(a_avg_per/feedp_size, 3) %>';
document.form1.a_cmp_per.value 	 = '<%= AddUtil.parseFloatCipher2(a_cmp_per/feedp_size, 3) %>';
document.form1.a_eff_per.value 	 = '<%=AddUtil.parseFloatCipher2(a_eff_per/feedp_size,3)  %>';	

//view_g2();
//view_max_cha();
//view_sum_amt();

//ķ���� ���ʽ� ���
function view_g2(){

	var fm = document.form1;	
	var size = toInt(fm.size.value)-<%=cnt%>;
//	var tot_dly_per = <%= AddUtil.parseFloatCipher2(sum_tot_amt2/sum_tot_amt1*100, 2) %>;
	var tot_dly_per = <%= AddUtil.parseFloatCipher2(a_cmp_per/feedp_size, 2) %>;	
	var amt=0;
	var b_amt=0, b_amt_out=0, b_amt_in=0;
	var tot_amt=0, tot_amt_out=0, tot_amt_in=0;	

	//��갪 ���ϱ� ------------------------------------------------------------
	var v_amt=0, s_amt=0;;	
	for(i=0; i<size ; i++){	
		//�μ���տ�ü�� �̻��� ��� ��ü�ݾ� �հ�
		if(toFloat(tot_dly_per) >= toFloat(fm.cmp_per[i].value)){
			v_amt = v_amt + ((toFloat(tot_dly_per) - toFloat(fm.cmp_per[i].value)) * toFloat(fm.tot_fee_amt[i].value));
		}		
	}

	//����� ��� �ܰ� ���ϱ�
	s_amt = v_amt / ((<%=var5%>-tot_dly_per)*<%=var4%>);	
	amt = toInt(s_amt);		
	
	//--------------------------------------------------------------------------
	
	
	//����� ����ϱ�
	for(i=0; i<size ; i++){	
	
		if(amt > 0){			
			//���κ� ����� ���
			b_amt = (toFloat(tot_dly_per) - toFloat(fm.cmp_per[i].value)) * toFloat(fm.tot_fee_amt[i].value) / amt;
		}

		var std_amt = 120000; //���� 120,000��
		var user_per1;
		var user_per2;
			
		//�λ�------------------------------------------------------------	
		//if(fm.brch_id[i].value == 'B1'){					
		//	user_per1 = 0.67;//�ܱ���60%
		//	user_per2 = 0.33;//������40%
		//����------------------------------------------------------------	
		//}else if(fm.brch_id[i].value == 'D1'){		
		//	user_per1 = 0.75;//�ܱ���60%
		//	user_per2 = 0.25;//������40%
		//����------------------------------------------------------------			
		//}else{				
		//	user_per1 = 0.6;//�ܱ���60%
		//	user_per2 = 0.4;//������40%
			//20080704����
			user_per1 = 1;//�ܱ���60%
			user_per2 = 1;//������40%

		//}
		
		if(fm.partner_id[i].value == ''){
			user_per2 	= 0;
		}	
			
		if(b_amt <= 0){							//������� ������
			fm.b_amt_out[i].value 	= 0;
			fm.b_amt_in[i].value 	= 0;
		}else if(b_amt > 0 && b_amt < std_amt){	//������� 20���������϶�
			fm.b_amt_out[i].value 	= std_amt*user_per1;
			fm.b_amt_in[i].value 	= std_amt*user_per2;
		}else if(b_amt > std_amt){
			b_amt_out 				= th_rnd(b_amt*user_per1);	
			b_amt_in 				= th_rnd(b_amt*user_per2);	
			if(b_amt_out < std_amt*user_per1)		b_amt_out 	= std_amt*user_per1;
			if(b_amt_in  < std_amt*user_per2)		b_amt_in 	= std_amt*user_per2;
			fm.b_amt_out[i].value 	= b_amt_out;
			fm.b_amt_in[i].value 	= b_amt_in;
		}			
						
		tot_amt_out = tot_amt_out + toInt(fm.b_amt_out[i].value);
		tot_amt_in 	= tot_amt_in + toInt(fm.b_amt_in[i].value);
		tot_amt 	= tot_amt + (toInt(fm.b_amt_out[i].value)+toInt(fm.b_amt_in[i].value));
			
		fm.b_amt_out[i].value 	= parseDecimal(fm.b_amt_out[i].value)+"��";
		fm.b_amt_in[i].value 	= parseDecimal(fm.b_amt_in[i].value)+"��";
		
	}

	fm.size2.value = size;
	
	//���������� ��»� ����ϱ�-----------------------------------------------------------------------
	var max_cha = -99.00;
	var max_i = 0;	
	var min_i = 0;
	for(i=0; i<size ; i++){	
		fm.per_cha[i].value = parseFloatCipher3(toFloat(fm.per_0405[i].value)-toFloat(fm.cmp_per[i].value),2);
		//��ü�� �϶�ġ ���� ���� ���
		if(fm.b_amt_out[i].value == '0��'){
			if(max_cha < toFloat(fm.per_cha[i].value)){
			
				max_cha = fm.per_cha[i].value;		
				max_i = i;
			}
		//���� ����� ������ ���
		}else{
			if(min_i < i){
				min_i = i;
			}		
		}
	}
	fm.max_i.value = max_i;
	fm.b_amt_out[max_i].value 	= parseDecimal(th_rnd(toInt(parseDigit(fm.b_amt_out[min_i].value)) * 0.8))+"��";
	
	if(fm.partner_id[max_i].value != ''){
		fm.b_amt_in[max_i].value 	= parseDecimal(th_rnd(toInt(parseDigit(fm.b_amt_out[max_i].value)) * 1))+"��";	
	}
	
	fm.cont[max_i].value 		= '-��»�-';
	//���������� ��»� ����ϱ�-----		
	
	//�հ� ���
	fm.tot_amt_out.value 	= parseDecimal(th_rnd(tot_amt_out+toInt(parseDigit(fm.b_amt_out[max_i].value))));
	fm.tot_amt_in.value 	= parseDecimal(th_rnd(tot_amt_in+toInt(parseDigit(fm.b_amt_in[max_i].value))));
	fm.tot_amt.value 		= parseDecimal(th_rnd(toInt(parseDigit(fm.tot_amt_out.value))+toInt(parseDigit(fm.tot_amt_in.value))));	
	
}		

//��»� ǥ��
function view_max_cha(){

	var fm = document.form1;	
	var size = toInt(fm.size.value)-<%=cnt%>;
	var tot_amt=0, tot_amt_out=0, tot_amt_in=0;	
	
	fm.size2.value = size;
	
	//���������� ��»� ����ϱ�-----------------------------------------------------------------------
	var max_cha = -99.00;
	var max_i = 0;	
	var min_i = 0;
	for(i=0; i<size ; i++){	
		fm.per_cha[i].value = parseFloatCipher3(toFloat(fm.per_0405[i].value)-toFloat(fm.cmp_per[i].value),2);
		if(toFloat(fm.a_cmp_per.value) < toFloat(fm.cmp_per[i].value) && toInt(parseDigit(fm.b_amt_out[i].value))>0){
			fm.cont[i].value 		= '-��»�-';	
			max_i = i;
		}
		tot_amt_out += toInt(parseDigit(fm.b_amt_out[i].value));
		tot_amt_in 	+= toInt(parseDigit(fm.b_amt_in[i].value));
		tot_amt 	+= toInt(parseDigit(fm.b_amt_out[i].value))+toInt(parseDigit(fm.b_amt_in[i].value));		
	}
	fm.max_i.value = max_i;
	//�հ� ���
	fm.tot_amt_out.value 	= parseDecimal(tot_amt_out);
	fm.tot_amt_in.value 	= parseDecimal(tot_amt_in);
	fm.tot_amt.value 		= parseDecimal(tot_amt);		
}	

//�հ�
function view_sum_amt(){

	var fm = document.form1;	
	var size = toInt(fm.size.value)-<%=cnt%>;
	var tot_amt=0, tot_amt_out=0, tot_amt_in=0;	
	
	fm.size2.value = size;
	
	for(i=0; i<size ; i++){	
		tot_amt_out += toInt(parseDigit(fm.b_amt_out[i].value));
		tot_amt_in 	+= toInt(parseDigit(fm.b_amt_in[i].value));
		tot_amt 	+= toInt(parseDigit(fm.b_amt_out[i].value))+toInt(parseDigit(fm.b_amt_in[i].value));		
	}
	//�հ� ���
	fm.tot_amt_out.value 	= parseDecimal(tot_amt_out);
	fm.tot_amt_in.value 	= parseDecimal(tot_amt_in);
	fm.tot_amt.value 		= parseDecimal(tot_amt);		
}


//onprint();

//5���Ŀ� �μ�ڽ� �˾�
//setTimeout(onprint_box,1000);


function onprint(){
	factory.printing.header 	= ""; //��������� �μ�
	factory.printing.footer 	= ""; //�������ϴ� �μ�
	factory.printing.portrait 	= false; //true-�����μ�, false-�����μ�    
	factory.printing.leftMargin 	= 10.0; //��������   
	factory.printing.rightMargin 	= 10.0; //��������
	factory.printing.topMargin 	= 10.0; //��ܿ���    
	factory.printing.bottomMargin 	= 10.0; //�ϴܿ���
}
function onprint_box(){
	factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}
//-->
</script>
</body>
</html>
