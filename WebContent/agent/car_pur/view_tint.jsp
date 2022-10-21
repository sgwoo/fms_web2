<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*, acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.tint.*, acar.car_office.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	//��ǰ����
	TintBean tint 	= t_db.getTint(rent_mng_id, rent_l_cd);
	
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
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
      <td>
    	<table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>��ǰ��û����</span></span></td>
			<td class=bar align=right></td>
            <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
	<tr>
	  <td align="right">&nbsp;</td>
	<tr> 	
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
            <td class=title width=10% style='height:36'>�����ȣ</td>
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
		</table>
	  </td>
	</tr>
	<tr>
	    <td></td>
	</tr>	 	
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
            <td class=title>��ǰ��û����</td>
            <td colspan="3">&nbsp;
			  <input type='checkbox' name="tint_yn" value='Y' <%if(!tint.getTint_no().equals(""))%>checked<%%>>��û�Ѵ�
			</td>
          </tr>		
          <tr> 
            <td colspan="2" class=title>����</td>
            <td colspan="2" class=title>û�ҿ�ǰ</td>
          </tr>
          <tr>
            <td width="10%" class=title>�ʸ�����</td>
            <td width="40%" >&nbsp;
			  <input type='radio' name="film_st" value=''  <%if(tint.getFilm_st().equals(""))%>checked<%%>>
				����
			  <input type='radio' name="film_st" value='1' <%if(tint.getFilm_st().equals("1"))%>checked<%%>>
				�Ϲ�
			  <input type='radio' name="film_st" value='2' <%if(tint.getFilm_st().equals("2"))%>checked<%%> <%if(tint.getFilm_st().equals("") && car.getSun_per()>0)%>checked<%%>>
				3M
			  <input type='radio' name="film_st" value='3' <%if(tint.getFilm_st().equals("3"))%>checked<%%>>
				�縶
			</td>
            <td width="10%" class=title>�⺻</td>
            <td width="40%">&nbsp;
			  <input type='radio' name="cleaner_st" value='1' <%if(tint.getCleaner_st().equals("1"))%>checked<%%>>
				����
			  <input type='radio' name="cleaner_st" value='2' <%if(tint.getCleaner_st().equals("2"))%>checked<%%>>
				����
            </td>
          </tr>
          <tr>
            <td class=title>���ñ���������</td>
            <td>&nbsp;
			  <input type='text' name='sun_per' size='3' <%if(!tint.getTint_no().equals("")){%>value='<%=tint.getSun_per()%>'<%}else{%>value='<%=car.getSun_per()%>'<%}%> class='default' >%
			</td>
            <td class=title>�߰�</td>
            <td>&nbsp;
                <input type='text' name='cleaner_add' size='60' value='<%=tint.getCleaner_add()%>' class='default' >
            </td>
          </tr>
          <tr> 
            <td colspan="2" class=title>�׺���̼�</td>
            <td colspan="2" class=title>��Ÿ</td>
          </tr>
          <tr>
            <td width="10%" class=title>��ǰ��</td>
            <td>&nbsp;
                <input type='text' name='navi_nm' size='60' value='<%=tint.getNavi_nm()%>' class='default' >
            </td>
            <td colspan="2" rowspan="2">&nbsp;
			  <textarea name="sup_other" cols="57" rows="2" class="default"><%=tint.getOther()%></textarea></td>
          </tr>
          <tr>
            <td class=title>(����)����</td>
            <td>&nbsp;
                <input type='text' name='navi_est_amt' maxlength='10' value='<%=AddUtil.parseDecimal(tint.getNavi_est_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
                �� </td>
          </tr>
          <tr>
            <td class=title>����</td>
            <td colspan="3">&nbsp;
			  <input type='text' name='sup_etc' size='141' value='<%=tint.getEtc()%>' class='default' >
			</td>
          </tr>
          <tr>
            <td class=title style='height:36'>�۾�����<br>��û�Ͻ�</td>
            <td>&nbsp;
			  <input type='text' size='12' name='sup_est_dt' maxlength='12' class='default' <%if(tint.getSup_est_dt().length()==10){%>value='<%=AddUtil.ChangeDate2(tint.getSup_est_dt().substring(0,8))%>'<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
			  <input type='text' size='2' name='sup_est_h' class='default' value=<%if(tint.getSup_est_dt().length()==10){%>'<%=tint.getSup_est_dt().substring(8)%>'<%}%>>��
			</td>
            <td class=title>��ü��</td>
            <td>&nbsp;
			  <select name='sup_off_id' class='default'>
                  <option value="">����</option>
                  <option value="002849�ٿȹ�"       <%if(tint.getOff_id().equals("002849"))%>selected<%%>>�ٿȹ�</option>
				  <option value="002850����ī����"     <%if(tint.getOff_id().equals("002850"))%>selected<%%>>����ī����</option>
				  <option value="002851����Ųõ������" <%if(tint.getOff_id().equals("002851"))%>selected<%%>>����Ųõ������</option>
                </select></td>
          </tr>	
          <tr>
            <td class=title>��û��</td>
            <td colspan="3">&nbsp;
			  <%=c_db.getNameById(tint.getReg_id(),"USER")%>&nbsp;
			  <%=AddUtil.ChangeDate2(tint.getReg_dt())%>
			</td>
          </tr>				  
		</table>
	  </td>
	</tr> 				
  </table>
</form>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

