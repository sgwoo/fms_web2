<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.tint.*, acar.doc_settle.*, acar.car_office.*, acar.cls.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%

	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String tint_no 	= request.getParameter("tint_no")==null?"":request.getParameter("tint_no");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	//��ǰ����
	TintBean tint 	= t_db.getTint(tint_no);
	
	if(tint_no.equals("")){
		tint 	= t_db.getTint(rent_mng_id, rent_l_cd);
		tint_no = tint.getTint_no();
	}
	
	if(rent_mng_id.equals("")){
		rent_mng_id = tint.getRent_mng_id();
		rent_l_cd 	= tint.getRent_l_cd();
	}
	
	//��������
	DocSettleBean doc = d_db.getDocSettleCommi("6", tint_no);
	
	//��������
	Hashtable est = a_db.getRentEst(rent_mng_id, rent_l_cd);
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//�������
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//��������
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var popObj = null;
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}		
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL;
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();			
	}	


	//����Ʈ
	function list(){
		var fm = document.form1;	
		if('<%=from_page%>' == ''){		
			fm.action = 'tint_i_frame.jsp';
		}else{
			fm.action = '<%=from_page%>';
		}
		fm.target = 'd_content';
		fm.submit();
	}	

	//�ѱݾװ��
	function set_tot_amt(){
		var fm = document.form1;
		fm.tot_amt.value = parseDecimal(toInt(parseDigit(fm.tint_amt.value)) + toInt(parseDigit(fm.cleaner_amt.value)) + toInt(parseDigit(fm.navi_amt.value)) + toInt(parseDigit(fm.blackbox_amt.value)) + toInt(parseDigit(fm.other_amt.value)));
	}
	
	//���
	function save(mode){
		var fm = document.form1;
		
		fm.mode.value = mode;
		
		if(fm.sup_est_dt.value  != ''  && fm.sup_est_h.value  == '') 		fm.sup_est_h.value 	= '00';		
		
		if(mode == 'settle'){
			if(fm.sup_dt.value  != ''  && fm.sup_h.value  == '') 		fm.sup_h.value 	= '00';		
			
			if(fm.sup_dt.value == '')	{	alert('�۾������Ͻø� �Է��Ͽ� �ֽʽÿ�.');		fm.sup_dt.focus(); 			return;		}
			//if(fm.tot_amt.value == '0')	{	alert('û���ݾ��� �Է��Ͽ� �ֽʽÿ�.');		fm.tot_amt.focus(); 		return;		}

			if(!confirm('���� �Ͻðڽ��ϱ�?'))	return;
			
		}else{
			if(!confirm('���� �Ͻðڽ��ϱ�?'))	return;		
		}
		
		fm.action='tint_reg_step2_a.jsp';		
		fm.target='i_no';
		fm.submit();
	}				
	
	//����
	function del_tint(){
		var fm = document.form1;
		
		if(!confirm('���� �Ͻðڽ��ϱ�?'))	return;
		if(!confirm('��¥�� ���� �Ͻðڽ��ϱ�?'))	return;
		if(!confirm('���������� �����ϴ�. ���� �Ͻðڽ��ϱ�?'))	return;				
		
		fm.action='tint_delete.jsp';		
		fm.target='i_no';
		fm.submit();

	}
	
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">

  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='from_page'	value='<%=from_page%>'>        
  <input type='hidden' name='mode' 		value='<%=mode%>'>            
  <input type='hidden' name='tint_no' 	value='<%=tint_no%>'>
  <input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
  <input type='hidden' name='rent_l_cd' value='<%=rent_l_cd%>'>  
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="car_nm" 		value="<%=cm_bean.getCar_nm()%>">
  
 <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
      <td>
    	<table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > ��ǰ���� > <span class=style5>��ǰ����</span></span></td>
            <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
	<tr>
	    <td align=right><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a></td></td>
	<tr> 	
	<%if(!tint.getRent_l_cd().equals("")){%>
    <tr>
      <td class=line2></td>
    </tr>    
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=10%>����ȣ</td>
            <td width=15%>&nbsp;<%=rent_l_cd%></td>
            <td class=title width=10%>��ȣ</td>
            <td colspan="3">&nbsp;<%=client.getFirm_nm()%></td>
            <td class=title width=10%>��������</td>
            <td colspan="5">&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>�縮��<%}else if(car_gu.equals("1")){%>����<%}else if(car_gu.equals("2")){%>�߰���<%}%></td>
		  </tr>	
          <tr> 
            <td class=title width=10%>���ۻ��</td>
            <td width=15%>&nbsp;<%=c_db.getNameById(emp2.getCar_comp_id(),"CAR_COM")%></td>
            <td class=title width=10%>����</td>
            <td colspan="3">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></td>
            <td class=title width=10%>����</td>
            <td width=15%>&nbsp;<%=car.getColo()%></td>
		  </tr>	
          <tr> 
            <td class=title width=10%>�����ȣ</td>
            <td width=15%>&nbsp;<%=pur.getCar_num()%></td>
            <td class=title width=10%>������ȣ</td>
            <td width=15%>&nbsp;<%=cr_bean.getCar_no()%></td>
            <td class=title width=10%>�ӽÿ���<br>�㰡��ȣ</td>
            <td width=15%>&nbsp;<%=pur.getTmp_drv_no()%></td>
            <td class=title width=10%>�μ���</td>
            <td width=15%>&nbsp;<%if(pur.getUdt_st().equals("1")){%>����<%}%><%if(pur.getUdt_st().equals("2")){%>����<%}%><%if(pur.getUdt_st().equals("3")){%>��<%}%></td>
		  </tr>
          <tr> 
            <td class=title width=10%>������Ͻ�</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_EST_DT")))%>&nbsp;<%=String.valueOf(est.get("DLV_EST_H"))%>��</td>
            <td class=title width=10%>�μ���������</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(pur.getUdt_est_dt())%></td>
            <td class=title width=10%>��Ͽ����Ͻ�</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(est.get("REG_EST_DT")))%>&nbsp;<%=String.valueOf(est.get("REG_EST_H"))%>��</td>
            <td class=title width=10%>��ǰ�����Ͻ�</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(est.get("RENT_EST_DT")))%>&nbsp;<%=String.valueOf(est.get("RENT_EST_H"))%>��</td>
		  </tr>
          <tr> 
            <td class=title width=10%>�������</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_DT")))%></td>
            <td class=title width=10%>�μ�����</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_DT")))%></td>
            <td class=title width=10%>�������</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(cr_bean.getInit_reg_dt())%></td>
            <td class=title width=10%>�뿩������</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%></td>
		  </tr>
          <tr> 
            <td class=title width=10%>�����ȣ</td>
            <td colspan='7'>&nbsp;<%=pur.getRpt_no()%></td>
		  </tr>		  		  		  
		  <%if(base.getUse_yn().equals("N")){%>
          <tr> 
            <td class=title width=10%>��������</td>
            <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(cls.getCls_dt())%></td>
            <td class=title width=10%>��������</td>
            <td width=15%>&nbsp;<%=cls.getCls_st()%></td>
            <td class=title width=10%>��������</td>
            <td colspan='3'>&nbsp;<%=HtmlUtil.htmlBR(cls.getCls_cau())%></td>
		  </tr>		  
		  <%}%>
		</table>
	  </td>
	</tr>	 
	<tr>
	  <td>&nbsp;</td>
	</tr> 
	<%}%> 
	<%if(!car.getAdd_opt().equals("")){%>		
    <tr>
      <td class=line2></td>
    </tr>    
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=10%>������߰�����</td>
            <td>&nbsp;<%=car.getAdd_opt()%>&nbsp;<%=AddUtil.parseDecimal(car.getAdd_opt_amt())%>��</td>
		  </tr>
		</table>
	  </td>
	</tr>	 
	<tr>
	  <td>&nbsp;</td>
	</tr>  		
	<%}%>
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǰ��û����</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
		  <tr>
		    <td colspan="2" class=title>��ǰ��ȣ</td>
			<td colspan="3">&nbsp;<%=tint.getTint_no()%></td>
		  </tr>
		  <%if(tint.getTint_cau().equals("1")){%>
                <tr>
                    <td colspan="2" class=title>�����ݿ���ǰ</td>
                    <td colspan="3">&nbsp;
		      <%if(car.getTint_b_yn().equals("Y")){%>2ä�� ���ڽ�<%}%>
                      &nbsp;
                      <%if(car.getTint_s_yn().equals("Y")){%>���� ����
                      &nbsp;
                      ���ñ��������� : <%=car.getTint_s_per()%> %
                      <%}%>        	      
      		      &nbsp;
                      <%if(car.getTint_n_yn().equals("Y")){%>��ġ�� ������̼�<%}%>
					  </td>
                </tr>					  
		  <%}%>		  
                <tr>
                    <td colspan="2" class=title>�������ǰ</td>
                    <td colspan="3">&nbsp;
        			  <%if(pur.getCom_tint().equals("")){%>����<%}%>
                      <%if(pur.getCom_tint().equals("1")){%>����<%}%>                      
                      <%if(pur.getCom_tint().equals("2")){%>�귣��ŰƮ<%}%>
					  </td>
                </tr>						
		  
          <tr> 
            <td colspan="3" class=title>����</td>
            <td colspan="2" class=title>û�ҿ�ǰ</td>
          </tr>
          <tr>
            <td width="5%" rowspan="2" class=title>�ʸ�</td>
            <td width="5%" class=title>�⺻</td>
            <td width="40%" >&nbsp;
				<%if(pur.getCom_film_st().equals("")){%>����<%}%>
                		<%if(pur.getCom_film_st().equals("1")){%>�縶<%}%>                      
        			<%if(pur.getCom_film_st().equals("2")){%>���<%}%>
				<%if(pur.getCom_film_st().equals("3")){%>SKC<%}%>
				<%if(pur.getCom_film_st().equals("4")){%>3M<%}%>
			</td>
            <td width="10%" rowspan="2" class=title>�⺻</td>
            <td width="40%" rowspan="2">&nbsp;
			  <select name='cleaner_st' class='default'>
						<option value="1" <%if(tint.getCleaner_st().equals("1")){%>selected<%}%>>����</option>
						<option value="2" <%if(tint.getCleaner_st().equals("2")){%>selected<%}%>>����</option>        				
              </select>
			</td>
          </tr>
          <tr>
            <td class=title>����</td>
            <td width="40%" >&nbsp;
			  <select name='film_st' class='default'>
					    <option value=""  <%if(tint.getFilm_st().equals("")){%>selected<%}%>>����</option>
						<option value="1" <%if(tint.getFilm_st().equals("1")){%>selected<%}%>>�Ϲ�</option>
						<option value="2" <%if(tint.getFilm_st().equals("2")){%>selected<%}%>>3M</option>        				
						<option value="3" <%if(tint.getFilm_st().equals("3")){%>selected<%}%>>�縶</option>        				
              </select>
		  </td>
          </tr>
          <tr>
            <td colspan="2" class=title>���ñ���������</td>
            <td>&nbsp;
			  <input type='text' name='sun_per' size='3' <%if(!tint.getTint_no().equals("")){%>value='<%=tint.getSun_per()%>'<%}else{%>value='<%=car.getSun_per()%>'<%}%> class='default' >%
			</td>
            <td class=title>�߰�</td>
            <td>&nbsp;
                <input type='text' name='cleaner_add' size='45' value='<%=tint.getCleaner_add()%>' class='default' >
            </td>
          </tr>
          <tr> 
            <td colspan="3" class=title>�׺���̼�</td>
            <td colspan="2" class=title>��Ÿ</td>
          </tr>
          <tr>
            <td width="10%" colspan="2" class=title>��ǰ��</td>
            <td>&nbsp;
                <input type='text' name='navi_nm' size='45' value='<%=tint.getNavi_nm()%>' class='default' >
            </td>
            <td colspan="2" rowspan="2">&nbsp;
			  <textarea name="sup_other" cols="57" rows="4" class="default"><%=tint.getOther()%></textarea></td>
          </tr>
          <tr>
            <td colspan="2" class=title>(����)����</td>
            <td>&nbsp;
                <input type='text' name='navi_est_amt' maxlength='10' value='<%=AddUtil.parseDecimal(tint.getNavi_est_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
                �� </td>
          </tr>
                <tr>
                    <td colspan="2" class=title>���ڽ�</td>
                    <td colspan="3">&nbsp;
                                �������� : 
        			  <select name='blackbox_yn' class='default'>
						<option value="" <%if(tint.getBlackbox_yn().equals("")){%>selected<%}%>>����</option>
						<option value="N" <%if(tint.getBlackbox_yn().equals("N")){%>selected<%}%>>������</option>
						<option value="Y" <%if(tint.getBlackbox_yn().equals("Y")){%>selected<%}%>>����</option>      
						<option value="3" <%if(tint.getBlackbox_yn().equals("3")){%>selected<%}%>>���(����)</option>        				
						<option value="4" <%if(tint.getBlackbox_yn().equals("4")){%>selected<%}%>>���(����)</option>       				
                      </select>
                      &nbsp;&nbsp;������/��ǰ�� : 
                      <input type='text' name='blackbox_nm' size='45' value='<%=tint.getBlackbox_nm()%>' class='default' >                      
                      <%if(!tint.getBlackbox_img().equals("")){%>
                          &nbsp;��:  <a href="javascript:MM_openBrWindow('blackbox/<%= tint.getBlackbox_img() %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><img src="http://fms1.amazoncar.co.kr/images/photo_s.gif" width="17" height="15" border="0"></a>                          
                      <%}%>      
                      <%if(!tint.getBlackbox_img2().equals("")){%>
                          &nbsp;�ǳ�:<a href="javascript:MM_openBrWindow('blackbox/<%= tint.getBlackbox_img2() %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><img src="http://fms1.amazoncar.co.kr/images/photo_s.gif" width="17" height="15" border="0"></a>                          
                      <%}%>            
        	    </td>
                </tr>            
          <tr>
            <td colspan="2" class=title>����</td>
            <td colspan="3">&nbsp;
			  <input type='text' name='sup_etc' size='90' value='<%=tint.getEtc()%>' class='default' >
			</td>
          </tr>
          <tr>
            <td colspan="2" class=title>�۾�����<br>��û�Ͻ�</td>
            <td>&nbsp;
			  <input type='text' size='11' name='sup_est_dt' maxlength='11' class='default' <%if(tint.getSup_est_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint.getSup_est_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
			  <input type='text' size='2' name='sup_est_h' class='default' value=<%if(tint.getSup_est_dt().length()==10){%>'<%=tint.getSup_est_dt().substring(8)%>'<%}%>>��
			</td>
            <td class=title>��ü��</td>
            <td>&nbsp;
			  <select name='sup_off_id' class='default'>
                  <option value="">����</option>
                  <option value="002849�ٿȹ�"       <%if(tint.getOff_id().equals("002849"))%>selected<%%>>�ٿȹ�</option>
				  <option value="008692�ֽ�ȸ�����ī��" <%if(tint.getOff_id().equals("008692"))%>selected<%%>>�ֽ�ȸ�� ����ī��</option>
				  <option value="002850����ī����"     <%if(tint.getOff_id().equals("002850"))%>selected<%%>>����ī����</option>
				  <option value="002851����Ųõ������" <%if(tint.getOff_id().equals("002851"))%>selected<%%>>����Ųõ������</option>
				   <option value="008501�ƽþƳ����" <%if(tint.getOff_id().equals("008501"))%>selected<%%>>�ƽþƳ����</option>
                </select></td>
          </tr>	
          <tr>
            <td colspan="2" class=title>��û��</td>
            <td colspan="3">&nbsp;
			  <%=c_db.getNameById(tint.getReg_id(),"USER")%>&nbsp;
			  <%=AddUtil.ChangeDate2(tint.getReg_dt())%>
			</td>
          </tr>				  
		</table>
	  </td>
	</tr> 
	<%if(emp2.getCar_comp_id().equals("0001")){%>
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;�� ������ ��ǰ���� : �� �縶���� �Ǵ� ��񽺽��� + �ؼ���������� �� �귣��ŰƮ(Ʈ��ũ������+�������̽�+���Ʈ������+������ɷ�+�ν��ɷ�+��������+��Ƽ���+������)</font> </td>
	</tr>				
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;�� �������ǰ�� �귣��ŰƮ �϶��� �Ƹ���ī���� û�ҿ�ǰ�� �������� �ʴ´�.</font> </td>
	</tr>				
	<%}%>
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;�� �ʸ� : �� �⺻-������ ���� �� ����-�Ƹ���ī ó��</font> </td>
	</tr>				
	<tr>
	  <td>&nbsp;</td>
	</tr>  	
	<%if(!doc.getUser_dt2().equals("") && doc.getUser_dt3().equals("")){%>
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��û���� ��ǰ���</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td width="10%" class=title>�۾������Ͻ�</td>
            <td colspan="6">&nbsp;
              <input type='text' size='11' name='sup_dt' maxlength='11' class='default' <%if(tint.getSup_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint.getSup_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
              <input type='text' size='2' name='sup_h' class='default' value=<%if(tint.getSup_dt().length()==10){%>'<%=tint.getSup_dt().substring(8)%>'<%}%>>
            ��			
			</td>
          </tr>
          <tr>
            <td rowspan="2" class=title>û���ݾ�</td>
            <td width="15%" class=title>���ú�</td>
            <td width="15%" class=title >û�ҿ�ǰ��</td>
            <td width="15%" class=title>�׺���̼�</td>
            <td width="15%" class=title>���ڽ�</td>
            <td width="15%" class=title >��Ÿ</td>
            <td width="15%" class=title>�ѱݾ�</td>            
          </tr>
          <tr>
            <td align="center" >&nbsp;
              <input type='text' name='tint_amt' maxlength='10' value='<%=AddUtil.parseDecimal(tint.getTint_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_amt();'>
				�� </td>
            <td align="center" >&nbsp;
              <input type='text' name='cleaner_amt' maxlength='10' value='<%=AddUtil.parseDecimal(tint.getCleaner_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_amt();'>
				�� </td>
            <td align="center" >&nbsp;
              <input type='text' name='navi_amt' maxlength='10' value='<%=AddUtil.parseDecimal(tint.getNavi_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_amt();'>
				�� </td>
            <td align="center" >&nbsp;
              <input type='text' name='blackbox_amt' maxlength='10' value='<%=AddUtil.parseDecimal(tint.getBlackbox_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_amt();'>
				�� </td>				
            <td align="center" >&nbsp;
              <input type='text' name='other_amt' maxlength='10' value='<%=AddUtil.parseDecimal(tint.getOther_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_amt();'>
				�� </td>
            <td align="center" >&nbsp;
              <input type='text' name='tot_amt' maxlength='10' value='<%=AddUtil.parseDecimal(tint.getTot_amt())%>' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
				�� </td>
          </tr>				  
		</table>
	  </td>
	</tr> 					
	<tr>
	  <td align="right">&nbsp;</td>
	<tr> 
	<%}%>
    <tr>
	  <td align='center'>
	    <%if(!doc.getUser_dt2().equals("") && doc.getUser_dt3().equals("")){%>
	    <a href="javascript:save('settle')" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_js.gif border=0 align=absmiddle></a>
		<%}%>
		&nbsp;&nbsp;&nbsp;
	    <a href="javascript:save('u')" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>				
	  </td>
	</tr>		
  </table>
</form>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

