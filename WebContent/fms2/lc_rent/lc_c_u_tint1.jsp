<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.tint.*, acar.user_mng.*, acar.client.*, acar.car_mst.*, acar.car_register.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();


	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String from_page2 	= request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�����⺻����
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");

	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));

	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
		
	//�����ݰ���
	Hashtable esti_exam = e_db.getEstimateResultVar(f_fee_etc.getBc_est_id(), "esti_exam");
		
	//��ǰ	
	TintBean tint1 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "1");
	TintBean tint2 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "2");
		
	//���������
	UsersBean user_bean 	= umd.getUsersBean(base.getBus_id());

	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
					

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//�ð����� ���ý�
	function cng_input(){		  
		var fm = document.form1;
		
		if(fm.tint_yn[0].checked == false && fm.tint_yn[1].checked == false && fm.tint_yn[2].checked == false && fm.tint_yn[3].checked == false){ alert('�ð������� �����Ͻʽÿ�.'); return;}
		
		if(fm.tint_yn[3].checked == true){
			fm.off_id.value = '';
		}else{
			if('<%=tint1.getTint_no()%>' == '' && '<%=tint2.getTint_no()%>' == ''){
				<%if(user_bean.getBr_id().equals("B1")||user_bean.getBr_id().equals("U1")){%>		fm.off_id.value = '010255������TS'; 
				<%}else if(user_bean.getBr_id().equals("D1")){%>					fm.off_id.value = '010937�ֽ�ȸ��̼���ũ';
				<%}else if(user_bean.getBr_id().equals("G1")){%>					fm.off_id.value = '008501�ƽþƳ����';
				<%}else if(user_bean.getBr_id().equals("J1")){%>					fm.off_id.value = '008680������ڵ�����ǰ��';
				<%}else{%>										                            fm.off_id.value = '002849�ٿȹ�'; 
				<%}%>
			}			
		}				
	}
	
	//�����ݿ�,���δ� ���ý�
	function cngCostEst(st, idx){
		var fm = document.form1;
		
		//������Ʈ,������� ���
		<%if(base.getBus_st().equals("2") || base.getBus_st().equals("7")){%>
		
		if(st == 'est_st'){
			if(fm.est_st[idx].value == 'Y'){
				fm.cost_st[idx].value = '1';
			}else{
				fm.cost_st[idx].value = '5';			
			}
		}
		
		if(st == 'cost_st'){
			if(fm.cost_st[idx].value == '1'){
				fm.est_st[idx].value = 'Y';
			}else{
				fm.est_st[idx].value = 'N';			
			}
		}
		
		
		<%}else{%>
		
		<%}%>
	}
	
	//����
	function update(){
		var fm = document.form1;
		
		if(fm.tint_yn[0].checked == false && fm.tint_yn[1].checked == false && fm.tint_yn[2].checked == false && fm.tint_yn[3].checked == false){ alert('�ð������� �����Ͻʽÿ�.'); return;}
		
		if(fm.tint_yn[3].checked == false && fm.off_id.value == ''){ alert('�ð���ü�� �����Ͻʽÿ�.'); return;}
		
		
		//���ĸ�
		if(fm.tint_yn[0].checked == true || fm.tint_yn[2].checked == true){
		
			if(fm.film_st[0].value == '')		{ alert('���ĸ� �ʸ������� �Ͻʽÿ�.');			return;}
			if(fm.sun_per[0].value == '')		{ alert('���ĸ� ���ñ����������� �����Ͻʽÿ�.');	return;}
			if(fm.cost_st[0].value == '')		{ alert('���ĸ� ���δ��� �����Ͻʽÿ�.');		return;}
			if(fm.est_st[0].value == '')		{ alert('���ĸ� �����ݿ��� �����Ͻʽÿ�.');		return;}
			if(fm.sup_est_dt[0].value == '')	{ alert('���ĸ� ��ġ���ڸ� �Է��Ͻʽÿ�.');		fm.sup_est_dt[0].focus();  return;}
			if(fm.sup_est_h[0].value == '' || fm.sup_est_h[0].value == '00')	{ alert('���ĸ� ��ġ���ڸ� �Է��Ͻʽÿ�.');			fm.sup_est_h[0].focus();  return;}
			if(fm.film_st[0].value == '4' && fm.film_st_etc[0].value == '')		{ alert('���ĸ� �ʸ����� ��Ÿ�� �̸��� �־��ּ���.'); 		fm.film_st_etc[0].focus();  return;}
			if(fm.est_st[0].value == 'Y' && toInt(fm.est_m_amt[0].value) == 0)	{ alert('���ĸ� �����ݿ��̸� ���ݿ��ݾ��� �Է����ּ���.'); 	fm.est_m_amt[0].focus();  return;}					

		}
		
		//����
		if(fm.tint_yn[1].checked == true || fm.tint_yn[2].checked == true){

			if(fm.film_st[1].value == '')		{ alert('���� �ʸ������� �Ͻʽÿ�.');			return;}
			if(fm.sun_per[1].value == '')		{ alert('���� ���ñ����������� �����Ͻʽÿ�.');		return;}
			if(fm.cost_st[1].value == '')		{ alert('���� ���δ��� �����Ͻʽÿ�.');		return;}
			if(fm.est_st[1].value == '')		{ alert('���� �����ݿ��� �����Ͻʽÿ�.');		return;}
			if(fm.sup_est_dt[1].value == '')	{ alert('���� ��ġ���ڸ� �Է��Ͻʽÿ�.');		fm.sup_est_dt[1].focus();  return;}
			if(fm.sup_est_h[1].value == '' || fm.sup_est_h[1].value == '00')	{ alert('���� ��ġ���ڸ� �Է��Ͻʽÿ�.');			fm.sup_est_h[1].focus();  return;}		
			if(fm.film_st[1].value == '4' && fm.film_st_etc[1].value == '')		{ alert('���� �ʸ����� ��Ÿ�� �̸��� �־��ּ���.'); 		fm.film_st_etc[1].focus();  return;}
			if(fm.est_st[1].value == 'Y' && toInt(fm.est_m_amt[1].value) == 0)	{ alert('���� �����ݿ��̸� ���ݿ��ݾ��� �Է����ּ���.'); 	fm.est_m_amt[1].focus();  return;}
			
		}
		
				
		if(confirm('�����Ͻðڽ��ϱ�?')){	
			fm.action='lc_c_u_tint1_a.jsp';		
			//fm.target='i_no';
			fm.submit();
		}									
	}			
				
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='lc_c_u_tint1_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 			value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 			value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 			value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 			value='<%=end_dt%>'>    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type='hidden' name='from_page2'	 	value='<%=from_page2%>'>   
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
     
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>��ǰ�Ƿ� ����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
	<td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>����ȣ</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>��ȣ</td>
                    <td width=20%>&nbsp;<%=client.getFirm_nm()%></td>
                    <td class=title width=10%><%if(cr_bean.getCar_no().equals("")){%>����<%}else{%>������ȣ<%}%></td>
                    <td>&nbsp;<%=cr_bean.getCar_no()%>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
                </tr>
  	    </table>
	 </td>
    </tr>  	                  
    <tr>
        <td class=h></td>
    </tr>  
	<td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>      
                <tr> 
                    <td class=title width=13%>�����ݿ���ǰ</td>
                    <td>&nbsp;
                    	<%if(car.getTint_s_yn().equals("Y")){%>
                    	<label><input type="checkbox" name="tint_s_yn" value="Y" <%if(car.getTint_s_yn().equals("Y")){%>checked<%}%>> ���� ����(�⺻��)</label>,
                        ���ñ��������� :
                        <input type='text' name="tint_s_per" value='<%=car.getTint_s_per()%>' size="4" maxlength="4" class='text'>
        	              % 
      		              &nbsp;
      		            <%}%>  
      		            <%if(car.getTint_ps_yn().equals("Y")){%>
      		            <label><input type="checkbox" name="tint_ps_yn" value="Y" <%if(car.getTint_ps_yn().equals("Y")){%>checked<%}%>> ��޽���</label>&nbsp;&nbsp;
      		            ���� <%=car.getTint_ps_nm()%>&nbsp; �ݾ� <%=AddUtil.parseDecimal(car.getTint_ps_amt())%> �� (�ΰ�������)
					        	  <%}%>      	
					          </td>
                </tr>                
  	    </table>
	 </td>
    </tr>  	  
    <tr>
	<td align="right">&nbsp;</td>
    <tr>
    <input type='hidden' name="tint_no"	 		value="<%=tint1.getTint_no()%>">
    <input type='hidden' name="tint_no"	 		value="<%=tint2.getTint_no()%>">
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle><span class=style2>����(���ĸ�/����)</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td colspan='2' class='title'>�ð�����</td>
                    <td width='37%' >&nbsp;
                        <%if(tint1.getTint_no().equals("")) tint1.setTint_yn("Y"); %>
                        <%if(tint2.getTint_no().equals("")) tint2.setTint_yn(car.getTint_s_yn()==""?"N":car.getTint_s_yn()); %>
                        <input type='radio' name="tint_yn" value='1' onClick="javascript:cng_input()" <%if(tint1.getTint_yn().equals("Y") && tint2.getTint_yn().equals("N"))%>checked<%%>>���ĸ�
                        <input type='radio' name="tint_yn" value='2' onClick="javascript:cng_input()" <%if(tint1.getTint_yn().equals("N") && tint2.getTint_yn().equals("Y"))%>checked<%%>>����
                        <input type='radio' name="tint_yn" value='3' onClick="javascript:cng_input()" <%if(tint1.getTint_yn().equals("Y") && tint2.getTint_yn().equals("Y"))%>checked<%%>>���ĸ�+����
                        <input type='radio' name="tint_yn" value='N' onClick="javascript:cng_input()" <%if(tint1.getTint_yn().equals("N") && tint2.getTint_yn().equals("N"))%>checked<%%>>�ð���������
                    </td>
                    <td colspan='2' class='title'>�ð���ü</td>
                    <td colspan='2' width='37%'>&nbsp;
                        <select name='off_id' class='default'>
                            <option value="">����</option>
                            <option value="002849�ٿȹ�"        <%if(tint1.getOff_id().equals("002849") || tint2.getOff_id().equals("002849"))%>selected<%%>>�ٿȹ�(������)		</option>
                            <option value="010255������TS"     <%if(tint1.getOff_id().equals("010255") || tint2.getOff_id().equals("010255"))%>selected<%%>>������TS(�λ�)	</option>
                            <option value="010937�ֽ�ȸ��̼���ũ"  <%if(tint1.getOff_id().equals("010937") || tint2.getOff_id().equals("010937"))%>selected<%%>>�ֽ�ȸ��̼���ũ(����)</option>
                            <option value="008501�ƽþƳ����"    <%if(tint1.getOff_id().equals("008501") || tint2.getOff_id().equals("008501"))%>selected<%%>>�ƽþƳ����(�뱸)	</option>
                            <option value="008680������ڵ�����ǰ��" <%if(tint1.getOff_id().equals("008680") || tint2.getOff_id().equals("008680"))%>selected<%%>>������ڵ�����ǰ��(����)	</option>
                            <option value="002850����ī����"     <%if(tint1.getOff_id().equals("002850") || tint2.getOff_id().equals("002850"))%>selected<%%>>����ī����(�λ�)	</option>
                            <option value="999991������"        <%if(tint1.getOff_id().equals("999991") || tint2.getOff_id().equals("999991"))%>selected<%%>>������	        </option>
                            <option value="999992������"       <%if(tint1.getOff_id().equals("999992") || tint2.getOff_id().equals("999992"))%>selected<%%>>������	</option>
			                      <%if(tint1.getOff_id().equals("008692") || tint2.getOff_id().equals("008692")){%>
			                      <option value="008692�ֽ�ȸ�����ī��" <%if(tint1.getOff_id().equals("008692") || tint2.getOff_id().equals("008692"))%>selected<%%>>�ֽ�ȸ�� ����ī��</option>
			                      <%}%>
			                      <%if(tint1.getOff_id().equals("002851") || tint2.getOff_id().equals("002851")){%>
        		                <option value="002851����Ųõ������"  <%if(tint1.getOff_id().equals("002851") || tint2.getOff_id().equals("002851"))%>selected<%%>>����Ųõ������	</option>
			                      <%}%>
			                      <%if(tint1.getOff_id().equals("008514") || tint2.getOff_id().equals("008514")){%>
			                      <option value="008514��ȣ4WD���"   <%if(tint1.getOff_id().equals("008514") || tint2.getOff_id().equals("008514"))%>selected<%%>>��ȣ4WD���	</option>
			                      <%}%>
                        </select>
                    </td>
                </tr>                
                <tr> 
                    <td rowspan='2' width='7%' class='title'>�ʸ�����</td>
                    <td width='6%' class='title'>���ĸ�</td>
                    <td>&nbsp;
                        <select name='film_st' class='default'>
                            <option value="">����</option>
                            <option value="2" <%if(tint1.getFilm_st().equals("2"))%>selected<%%>>3M</option>
        		    <option value="3" <%if(tint1.getFilm_st().equals("3"))%>selected<%%>>�縶</option>
        		    <option value="5" <%if(tint1.getFilm_st().equals("5"))%>selected<%%>>�ֶ󰡵�</option>
        		    <option value="6" <%if(tint1.getFilm_st().equals("6"))%>selected<%%>>���</option>
        		    <option value="4" <%if(tint1.getFilm_st().equals("4"))%>selected<%%>>��Ÿ</option>
                        </select>                    
                        (����:<input type='text' name='film_st_etc' size='20' value='<%=tint1.getFilm_st()%>' class='default' >)
                    </td>
                    <td rowspan='2' width='7%' class='title'>���ñ���<br>������</td>
                    <td width='6%' class='title'>���ĸ�</td>
                    <td>&nbsp;
                        <%if(tint1.getTint_no().equals("")) tint1.setSun_per(car.getSun_per()); %>
                        <select name='sun_per' class='default'>
                            <option value="">����</option>
                            <option value="5" <%if(tint1.getSun_per() == 5)%>selected<%%>>5%</option>
                            <option value="15" <%if(tint1.getSun_per() == 15)%>selected<%%>>15%</option>
        		    <option value="35" <%if(tint1.getSun_per() == 35)%>selected<%%>>35%</option>
        		    <option value="50" <%if(tint1.getSun_per() == 50)%>selected<%%>>50%</option>
                        </select>                    
                    </td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;
                        <select name='film_st' class='default'>
                            <option value="">����</option>
                            <option value="2" <%if(tint2.getFilm_st().equals("2"))%>selected<%%>>3M</option>
        		    <option value="3" <%if(tint2.getFilm_st().equals("3"))%>selected<%%>>�縶</option>
        		    <option value="5" <%if(tint2.getFilm_st().equals("5"))%>selected<%%>>�ֶ󰡵�</option>
        		    <option value="6" <%if(tint2.getFilm_st().equals("6"))%>selected<%%>>���</option>
        		    <option value="4" <%if(tint2.getFilm_st().equals("4"))%>selected<%%>>��Ÿ</option>
                        </select>                    
                        (����:<input type='text' name='film_st_etc' size='20' value='<%=tint2.getFilm_st()%>' class='default' >)
                    </td>
                    <td class='title'>����</td>
                    <td>&nbsp;
                        <%if(tint2.getTint_no().equals("")) tint2.setSun_per(car.getTint_s_per()); %>
                        <select name='sun_per' class='default'>
                            <option value="">����</option>
                            <option value="15" <%if(tint2.getSun_per() == 15)%>selected<%%>>15%</option>
        		    <option value="35" <%if(tint2.getSun_per() == 35)%>selected<%%>>35%</option>
        		    <option value="50" <%if(tint2.getSun_per() == 50)%>selected<%%>>50%</option>
                        </select>                                        
                    </td>
                </tr>
                <tr> 
                    <td rowspan='2' width='7%' class='title'>���δ�</td>
                    <td width='6%' class='title'>���ĸ�</td>
                    <td>&nbsp;
                        <%if(tint1.getTint_no().equals("")) tint1.setCost_st("1"); %>
                        <select name='cost_st' class='default'>
                            <option value="">����</option>
                            <option value="1" <%if(tint1.getCost_st().equals("1"))%>selected<%%>>����</option>
                            <%if(base.getCar_st().equals("2") || (!base.getBus_st().equals("2") && !base.getBus_st().equals("7"))){%>
        		    <option value="2" <%if(tint1.getCost_st().equals("2"))%>selected<%%>>��</option>
        		    <option value="4" <%if(tint1.getCost_st().equals("4"))%>selected<%%>>���</option>
        		    <%}%>
        		    <option value="5" <%if(tint1.getCost_st().equals("5"))%>selected<%%>>������Ʈ</option>
                        </select>                                        
                    </td>
                    <td rowspan='2' width='7%' class='title'>�����ݿ�</td>
                    <td width='6%' class='title'>���ĸ�</td>
                    <td>&nbsp;
                        <%if(tint1.getTint_no().equals("")) tint1.setEst_st("N"); %>
                        <select name='est_st' class='default'>
                            <option value="">����</option>
                            <option value="Y" <%if(tint1.getEst_st().equals("Y"))%>selected<%%>>�ݿ�</option>
        		    <option value="N" <%if(tint1.getEst_st().equals("N"))%>selected<%%>>�̹ݿ�</option>        		    
                        </select>     
                        (�ݿ�:��<input type='text' name='est_m_amt' size='10' class='defaultnum' value='<%=AddUtil.parseDecimal(tint1.getEst_m_amt())%>'>��)
                    </td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;
                        <%if(tint2.getTint_no().equals("") && (car.getTint_s_yn().equals("Y")||car.getTint_ps_yn().equals("Y"))) tint2.setCost_st("1"); %>                        
                        <select name='cost_st' class='default' onChange="javascript:cngCostEst('cost_st',1);">
                            <option value="">����</option>
                            <option value="1" <%if(tint2.getCost_st().equals("1"))%>selected<%%>>����</option>
                            <%if(base.getCar_st().equals("2") || (!base.getBus_st().equals("2") && !base.getBus_st().equals("7"))){%>
        		    <option value="2" <%if(tint2.getCost_st().equals("2"))%>selected<%%>>��</option>
        		    <option value="4" <%if(tint2.getCost_st().equals("4"))%>selected<%%>>���</option>
        		    <%}%>
        		    <option value="5" <%if(tint2.getCost_st().equals("5"))%>selected<%%>>������Ʈ</option>
                        </select>                                                                             
                    </td>
                    <td class='title'>����</td>
                    <td>&nbsp;
                        <%if(tint2.getTint_no().equals("") && (car.getTint_s_yn().equals("Y")||car.getTint_ps_yn().equals("Y"))) tint2.setEst_st("Y"); %>
                        <%if(tint2.getTint_no().equals("") && car.getTint_s_yn().equals("Y") && AddUtil.parseInt(String.valueOf(esti_exam.get("AX117_S"))==null?"":String.valueOf(esti_exam.get("AX117_S"))) >0) tint2.setEst_m_amt(AddUtil.parseInt(String.valueOf(esti_exam.get("AX117_S")))); %>
                        <%if(tint2.getTint_no().equals("") && car.getTint_ps_yn().equals("Y") && AddUtil.parseInt(String.valueOf(esti_exam.get("AX117_PS"))==null?"":String.valueOf(esti_exam.get("AX117_PS"))) >0) tint2.setEst_m_amt(AddUtil.parseInt(String.valueOf(esti_exam.get("AX117_PS")))); %>
                        <select name='est_st' class='default' onChange="javascript:cngCostEst('est_st',1);">
                            <option value="">����</option>
                            <option value="Y" <%if(tint2.getEst_st().equals("Y"))%>selected<%%>>�ݿ�</option>
        		    <option value="N" <%if(tint2.getEst_st().equals("N"))%>selected<%%>>�̹ݿ�</option>        		    
                        </select>     
                        (�ݿ�:��<input type='text' name='est_m_amt' size='10' class='defaultnum' value='<%=AddUtil.parseDecimal(tint2.getEst_m_amt())%>'>��)
                    </td>
                </tr>
                <tr> 
                    <td rowspan='2' width='7%' class='title'>��ġ����</td>
                    <td width='6%' class='title'>���ĸ�</td>
                    <td>&nbsp;
                        <input type='text' size='11' name='sup_est_dt' maxlength='10' class='default' <%if(tint1.getSup_est_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint1.getSup_est_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
        		<input type='text' size='2' name='sup_est_h' maxlength='2' class='default' value=<%if(tint1.getSup_est_dt().length()==10){%>'<%=tint1.getSup_est_dt().substring(8)%>'<%}%>>�ñ��� ��û��
                    </td>
                    <td rowspan='2' width='7%' class='title'>��ġ���</td>
                    <td width='6%' class='title'>���ĸ�</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(tint1.getTint_amt())%>��</td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td>&nbsp;
                        <input type='text' size='11' name='sup_est_dt' maxlength='10' class='default' <%if(tint2.getSup_est_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint2.getSup_est_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
        		<input type='text' size='2' name='sup_est_h' maxlength='2' class='default' value=<%if(tint2.getSup_est_dt().length()==10){%>'<%=tint2.getSup_est_dt().substring(8)%>'<%}%>>�ñ��� ��û��
                    </td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(tint2.getTint_amt())%>��</td>
                </tr>    
                <tr> 
                    <td colspan='2' class='title'>���</td>
                    <td colspan='4'>&nbsp;
                        <input type='text' name='etc' size='100' value='<%=tint1.getEtc()%>' class='default' ></td>
                </tr>                                 
                            
            </table>
	</td>
    </tr>    
    <tr>
	<td>* ���δ� : ���� �̹ݿ��� ��� ���� ����� �߻��ϸ� �� ����� �δ��� ��ü�� ���� ������ �Է��ϼ���. ������ ������ �����Դϴ�.</td>
    </tr>	
    <tr>
	<td>* ������ ������ ��쿡�� ����Ͽ� �ֽʽÿ�. (���д�-����, �����ݿ�-�̹ݿ�)</td>
    </tr>	
    <tr>
	<td align='center'>&nbsp;</td>
    </tr>	
    <tr>
        <td align='center'>
        <%if(tint1.getPay_dt().equals("") && tint2.getPay_dt().equals("")){%>
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	  	<a href='javascript:update();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a> 
	  	&nbsp;
	    <%}%>
	    <%}%>
	    <a href='javascript:window.close();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a> 
  	</td>
    </tr>            
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	cng_input();
//-->
</script>
</body>
</html>