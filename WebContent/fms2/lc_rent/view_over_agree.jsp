<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*,acar.credit.*, acar.car_mst.*, acar.car_register.*,acar.ext.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?acar_br:request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String tot_dist 	= request.getParameter("tot_dist")==null?"":request.getParameter("tot_dist");
	String cls_st 	= request.getParameter("cls_st")==null?"1":request.getParameter("cls_st");
	String cls_dt 	= request.getParameter("cls_dt")==null?"":AddUtil.replace(request.getParameter("cls_dt"),"-","");
	
	if(rent_l_cd.equals("")) return;
	
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	if(base.getUse_yn().equals("N"))	return;
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
		
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//3. �뿩-----------------------------		
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	ContCarBean  car1 = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1"); // ���ʷ� -20161219 �ʰ�����δ�� �߰������� ���� �ʱ⿡  
	
	if(cls_dt.equals("")){
		cls_dt = ext_fee.getRent_end_dt();
	}

	
	//�⺻����
	Hashtable base1 = as_db.getSettleBase(rent_mng_id, rent_l_cd, cls_dt, "");
	
	//�����Ī������ ���� ���������Ϻ��� ����Ÿ����
	String taecha_st_dt = "";
	
	//taecha_st_dt = ac_db.getClsEtcTaeChaStartDt(rent_mng_id, rent_l_cd, base.getCar_mng_id() );
	
	//�ʰ�����Ÿ������
	Vector dists = ae_db.getExtScd(rent_mng_id, rent_l_cd, "8");
	int dist_size = dists.size();
	
  	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
<script language="JavaScript">
<!--	
function set_amt(obj)
{
	var fm = document.form1;
	obj.value = parseDecimal(obj.value);
	if(obj==fm.pp_s_amt){
		fm.pp_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) * 0.1 );
		fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));
	}
	if(obj==fm.pp_v_amt){
		fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));
	}
	if(obj==fm.pp_amt){ 
		fm.pp_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.pp_amt.value))));
		fm.pp_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.pp_amt.value)) - toInt(parseDigit(fm.pp_s_amt.value)));
	}
}	

function reg_grt(){
	var fm = document.form1;
	if(parseDigit(fm.pp_s_amt.value).length == 0)	{	alert('���ް��� Ȯ���Ͻʽÿ�');		return;	}
	if(parseDigit(fm.pp_v_amt.value).length == 0)	{	alert('�ΰ����� Ȯ���Ͻʽÿ�');		return;	}
	if(parseDigit(fm.pp_amt.value).length == 0)		{	alert('�հ踦 Ȯ���Ͻʽÿ�');			return;	}
	if(fm.pp_est_dt.value == '')					{	alert('�Աݿ������� Ȯ���Ͻʽÿ�');		return;	}
	fm.target='i_no';
	fm.action='/fms2/con_grt/grt_scd_i_a.jsp';
	fm.submit();	
}

//����� ����Ÿ� ���� ó�� 
function Disp(){
	var fm = document.form1;		
	opener.form1.over_amt.value 		= fm.j_over_amt.value;
	opener.form1.dist_msg.value 		= '';
	
	opener.set_init();	
	
	self.close();
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
<form action='' name="form1" method='post'>
 <!--�ʰ����� �Ÿ� ��� -->
 <input type='hidden' name='agree_dist' value='<%=car1.getAgree_dist()%>'>
 <input type='hidden' name='rtn_run_amt' value='<%=car1.getRtn_run_amt()%>'>
 <input type='hidden' name='rtn_run_amt_yn' value='<%=car1.getRtn_run_amt_yn()%>'>
 <input type='hidden' name='over_run_amt' value='<%=car1.getOver_run_amt()%>'>
 <!-- <input type='hidden' name='taecha_st_dt' value='<%=taecha_st_dt%>'>--><!--�����Ī���� ������ -->
 <input type='hidden' name='cls_dt' value='<%=cls_dt%>'>
 <input type='hidden' name='cls_st' value='<%=cls_st%>'>
 <input type='hidden' name='tot_dist' value='<%=tot_dist%>'>
 <input type='hidden' name='m_id' value='<%=rent_mng_id%>'>
 <input type='hidden' name='l_cd' value='<%=rent_l_cd%>'>
 <input type='hidden' name='r_st' value='<%=rent_st%>'>
 <input type='hidden' name='p_st' value='8'>
 <input type='hidden' name='pp_tm' value='1'>
 
 

  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
 	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width=10% class=title>��ȣ</td>
            <td width=40% >&nbsp;<%=client.getFirm_nm()%></td>
            <td width=10% class=title>��ǥ��</td>
            <td width=40% >&nbsp;<%=client.getClient_nm()%></td>
          </tr>
          <tr>
            <td class=title>������ȣ</td>
            <td>&nbsp;<%=cr_bean.getCar_no()%>
                &nbsp;<font color="red">(����: <%=base1.get("CAR_MON")%>����, ���ɸ�����:<%=cr_bean.getCar_end_dt()%> ) 
             <% if ( cr_bean.getCar_end_yn().equals("Y") )  {%>��������<%} %>
              </font>  
            </td>
            <td class=title>����</td>
            <td>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;
			<font color="#999999">(�����ڵ�:<%=cm_bean.getJg_code()%>)</font>
			</td>
          </tr>		  
        </table>
	  </td>
    </tr>
	<tr>
	  <td align="right">&nbsp;</td>
	</tr>     
      <!-- �ʰ�����δ�ݿ� ����  block none-->    
   	<tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ȯ��/�ʰ����� �뿩��[���ް�]</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>	
 	 	 	 	
 	 	   <tr> 
	        <td colspan="2" class='line'> 
	          <table border="0" cellspacing="1" cellpadding="0" width=100%>
		        <tr> 
	              <td class="title"  colspan="5"  width='34%'>����</td>
	              <td class="title" width='20%'>����</td>                
	              <td class="title" width='46%'>����</td>
	            </tr>
	            <tr> 
	              <td class="title"  rowspan="7" >��<br>��<br>��<br>��</td>   
	              <td class="title"  rowspan=4>��<br>��</td>
	              <td class="title"  colspan=3>���Ⱓ</td>
	              <td align="center" >&nbsp;<%=AddUtil.ChangeDate2((String) base1.get("RENT_START_DT"))%>~<%=AddUtil.ChangeDate2((String) base1.get("RENT_END_DT"))%> </td>
	              <td align="left" >&nbsp;���ʰ��Ⱓ</td>
	             </tr>
	             <tr> 
	              <td class="title" rowspan=3>����<br>�Ÿ�<br>����</td>
	              <td class="title"  colspan=2>���������Ÿ� (��)</td>
	              <td align="right" ><%=AddUtil.parseDecimal(car1.getAgree_dist() )%> km</td>
	              <td align="left" >&nbsp;</td>
	             </tr>  
	             <tr> 
	              <td class="title" rowspan=2>�ܰ�<br>(1km) </td>
	              <td class="title" >ȯ�޴뿩�� (a1)</td>
	              <td align="right" ><%=AddUtil.parseDecimal(car1.getRtn_run_amt() )%>��</td>
	              <td align="left" >&nbsp;�����Ÿ� ���Ͽ���</td>
	             </tr>            
	             <tr> 
	              <td class="title" >�ʰ�����뿩��(a2)</td>
	              <td align="right" ><%=AddUtil.parseDecimal(car1.getOver_run_amt() )%>��</td>
	               <td align="left" >&nbsp;�����Ÿ� �ʰ�����</td>
	            </tr>           
	            <tr> 
	              <td class="title"  rowspan=3>��<br>��</td>
	              <td class="title"  rowspan=2>�̿�<br>�Ⱓ</td>  
	              <td class="title"  colspan=2 >���̿�Ⱓ	</td>     
	              <td align="center">&nbsp;</td>
	              <td align="left" >&nbsp;�����뿩�Ⱓ</td>
	            </tr>   
            
	             <tr> 
	              <td class="title"  colspan=2 >���̿��ϼ�	(��)</td>
	              <td align="right" > <input type='text' name='rent_days' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("RENT_DAYS")))%>' size='7' class='whitenum' > �� </td>
	              <td align="left" >&nbsp;</td>
	             </tr>
	             <tr> 
	              <td class="title"  colspan=3 >�����Ÿ�(�ѵ�)(c)</td>
	              <td align="right" ><input type='text' name='cal_dist' readonly   size='7' class='whitenum' > km</td>
	               <td align="left" >&nbsp;=(��)x(��) / 365</td>
	             </tr>
	             <tr> 
	              <td class="title"  rowspan="6" >��<br>��<br>��<br>��</td>      
	              <td class="title"  rowspan=3>��<br>��</td>
	              <td class="title"  colspan=3 >��������Ÿ���(d)</td>
	             <td align="right" ><input type='text' name='first_dist' readonly  value = '<%=AddUtil.parseDecimal(car1.getSh_km() )%>'  size='7' class='whitenum' > km</td>
	              <td align="left" >&nbsp;����(�� �ε����� ����Ÿ�) , ������ (��༭�� ��õ� ����Ÿ�)</td>
	             </tr>   
	             <tr> 
	              <td class="title"  colspan=3>��������Ÿ���(e)</td>
	              <td align="right" ><input type='text' name='last_dist' readonly   size='7' class='whitenum' > km</td>
	              <td align="left" >&nbsp;</td>
	             </tr>              
	             <tr> 
	              <td class="title"  colspan=3 >�ǿ���Ÿ�(f)</td>
	              <td align="right" ><input type='text' name='real_dist' readonly    size='7' class='whitenum' > km</td>
	              <td align="left" >&nbsp;=(e)-(d) </td>
	             </tr>                      
	          
		         <tr> 
	              <td class="title"  rowspan=3>��<br>��</td>
	              <td class="title"   colspan=3 >������ؿ���Ÿ�	(g)</td>
	              <td align="right" ><input type='text' name='over_dist' readonly    size='7' class='whitenum' > km</td> 
	              <td align="left" >&nbsp;=(f)-(c) </td>
	             </tr>
	              <tr> 
	              <td class="title"   colspan=3 >�⺻�����Ÿ�</td>
	            <% if (  AddUtil.parseInt(base.getRent_dt()) > 20220414 ) { %>             
	              <td align="right" >&nbsp;��1,000 km</td>
	            <% } else { %>
	              <td align="right" >&nbsp;1,000 km</td>
	            <% }  %>  
	                <td align="left" >&nbsp;<input type='hidden' name='add_dist'  readonly class='whitenum' > </td>
	             </tr>      
	              <tr> 
	              <td class="title"  colspan=3 >�뿩��������ؿ���Ÿ�	(b)</td>
	              <td align="right" ><input type='text' name='jung_dist' readonly    size='7' class='whitenum' > km</td>
	               <% if (  AddUtil.parseInt(base.getRent_dt())  > 20220414 ) { %>  
	              <td align="left" >&nbsp;(g)�� ��1,000km �̳��̸� ������(0km) , (g)��  ��1,000km�� �ƴϸ� (g)���⺻�����Ÿ� </td>
	                <% } else { %>
	               <td align="left" >&nbsp;</td> 
	                <% }  %>
	             </tr>  
	             <tr> 
	              <td class="title"  rowspan=3>��<br>��<br>��</td>
	              <td class="title"  rowspan=2>��<br>��</td>
	              <td class="title"  colspan=3 >����ݾ�(h)</td>
	              <td align="right" ><input type='text' name='r_over_amt' readonly    size='10' class='whitenum' >��</td>
	              <td align="left" >&nbsp;(b)��  0km �̸��̸� (a1)*(b), (b)�� 1km�̻��̸� (a2)*(b)</td>
	             </tr>
	             
	             <tr> 
	              <td class="title"   colspan=3 >������(i)</td>
	              <td align="right"><input type='text' name='m_over_amt' readonly  size='10' class='whitenum'   onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
	              <td align="left" >&nbsp;<input type='text' name='m_reason' readonly  size='50' class='whitetext'></td>
	             </tr>      
	             <tr> 
	              <td class="title"  colspan=4 >����(�ΰ�/ȯ�޿���)�ݾ�</td>
	              <td align="right" ><input type='text' name='j_over_amt' readonly    size='10' class='whitenum' >��</td>
	              <td align="left" >&nbsp;=(h)-(i), ȯ��(-)</td>
	             </tr>  	          	            
                </table>
            </td>
         </tr>         
  
     	</table>
      </td>	 
    </tr>	  	 	        
    <tr>
	  <td align="center">
	  <a href='javascript:Disp()' onMouseOver="window.status=''; return true">[���꿡 �ݿ�]</a>
	  <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
	</tr>	  
  </table>  
  <%if(ck_acar_id.equals("000029")){ %>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ʰ�����Ÿ������ ������</span></td>
        <td align='right'>        
        </td>
    </tr>
    
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=5%  class='title'>����</td>				
                    <td width=6%  class='title'>ȸ��</td>
                    <td width=13% class='title'>���ް�</td>
                    <td width=13% class='title'>�ΰ���</td>
                    <td width=13% class='title'>�հ�</td>
                    <td width=13% class='title'>������</td>
                    <td width=13% class='title'>�Ա���</td>
                    <td width=13% class='title'>�Աݾ�</td>
                    <td width=13% class='title'>��꼭������</td>
                </tr>
          <%		for(int i = 0 ; i < dist_size ; i++){
			ExtScdBean grt = (ExtScdBean)dists.elementAt(i);
			%>
                <tr> 
                    <td align='center'><%if(grt.getRent_st().equals("1")){%>�ű�<%}else{%><%=AddUtil.parseInt(grt.getRent_st())-1%>������<%}%></td>				
                    <td align='center'><%=grt.getExt_tm()%>ȸ<%if(!grt.getExt_tm().equals("1")){%>(�ܾ�)<%}%></td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_s_amt())%></td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_v_amt())%></td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_s_amt()+grt.getExt_v_amt())%></td>
                    <td align='center'><%=grt.getExt_est_dt()%></td>
                    <td align='center'><%=grt.getExt_pay_dt()%></td>
                    <td align='right'><%=Util.parseDecimal(grt.getExt_pay_amt())%></td>
                    <td align='center'><%=grt.getExt_dt()%></td>                    			
                </tr>         
          <%		}%>
                <tr> 
                    <td align='center'>�߰�</td>				
                    <td align='center'>����</td>
                    <td align='center'><input type='text' name='pp_s_amt' value='' class='num'  size="8" onBlur="javascript:set_amt(this)"></td>
                    <td align='center'><input type='text' name='pp_v_amt' value='' class='num'  size="7" onBlur="javascript:set_amt(this)"></td>
                    <td align='center'><input type='text' name='pp_amt' value='' class='num'  size="8" onBlur="javascript:set_amt(this)"></td>
                    <td align='center'><input type='text' name='pp_est_dt' size='11' value='' class='text' maxlength='11' onBlur='javascript:this.value = ChangeDate(this.value);'></td>
                    <td align='center'><a href="javascript:reg_grt()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align='center'></td>
                    <td align='center'></td>                    			
                </tr>            
            </table>
        </td>
    </tr>  
    <%} %>
</table>    
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--

		var fm = document.form1;
					
		var cal_dist  = 0;
		
		cal_dist =   	 Math.floor(parseDigit(fm.agree_dist.value))  *Math.floor(parseDigit(fm.rent_days.value))   / 365;
		
		fm.m_reason.value = "";
		
	  	// fm.taecha_st_dt ���� �ִٸ� �����Ī �̾ �뿩�����Ϻ��� ��� - over �Ǹ� ������ ���ؼ� ó��
	  	
	//	if ( fm.taecha_st_dt.value  != "" )  {
	//		var s1_str = fm.taecha_st_dt.value; 
	//		var e1_str = fm.cls_dt.value;
	//		var  count1 = 0;
	//		var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
	//		var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1,  e1_str.substring(8,10) );
	//	  	var diff1_date = e1_date.getTime() - s1_date.getTime();
	//	 	count1 = Math.floor(diff1_date/(24*60*60*1000));
	//		cal_dist =   	 Math.floor(parseDigit(fm.agree_dist.value))  * count1/ 365;
	//	}
		
		//�ʱ�ȭ 
		fm.cal_dist.value 		=     parseDecimal( Math.round(cal_dist)  );				
		fm.last_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value))   );	
		fm.real_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value)) -   toInt(parseDigit(fm.first_dist.value))     );		  
		fm.over_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.real_dist.value)) -   toInt(parseDigit(fm.cal_dist.value))     )
	//	fm.add_dist.value 		=     parseDecimal( 1000  );  //��񽺸��ϸ���
	//	fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );
		
	    //����� 20220414 ���ĸ� ȯ��
		if (  <%=base.getRent_dt()%>  > 20220414 ) {  
			// 2022-05 ����  over_dist��  0 ���� ũ�� 1000, 0  ������ -1000 ó�� - �⺻����ó���� 
			if ( -1000 <= toInt(parseDigit(fm.over_dist.value)) &&  toInt(parseDigit(fm.over_dist.value)) <= 1000  ) {
					fm.add_dist.value 		=  '0';  //�⺻����ó�� 
					fm.jung_dist.value 		=  '0';			
			} else {
					// 2022-05 ����  over_dist��  0 ���� ũ�� 1000, 0  ������ -1000 ó�� - �⺻����ó���� 
					if (toInt(parseDigit(fm.over_dist.value)) >= 0  ) {
						fm.add_dist.value 		=     parseDecimal( 1000  );  //�⺻����ó�� 			
					} else {
						fm.add_dist.value 		=     parseDecimal( -1000  );  //�⺻����ó�� 	
					}
					fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) - toInt(parseDigit(fm.add_dist.value))     );
			}
		} else {
			fm.add_dist.value 		=     parseDecimal( 1000  );  //��񽺸��ϸ���	(�����ΰ�� �����Ⱓ ǥ��)
			fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );					
		}
		//�ߵ��ؾ�, ��ุ���� ���
		if ( fm.cls_st.value == '1' || fm.cls_st.value == '2'  ) { 
		       
			if ( (  <%=base.getRent_dt()%>  > 20130604  &&    <%=car1.getAgree_dist()%>  > 0   &&  <%=base.getCar_gu()%>  ==  '1' ) ||    (  <%=base.getRent_dt()%>  > 20140705  &&  <%=base.getCar_gu()%>  ==  '0' )   ) {  
						     
				 // fm.taecha_st_dt ���� �ִٸ� �����Ī - 20210330 ������ ���� �ʰ�����뿩�� �������� ���� - ���� �����Ī�� ��� ������ �ʰ�����δ�� �������� ó�� 
			//	if ( fm.taecha_st_dt.value  != "" )  {			
			//		var s1_str = fm.taecha_st_dt.value; 
			//		var e1_str = fm.cls_dt.value;
			//		var  count1 = 0;
					  
			//		var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );								
			//		var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1,  e1_str.substring(8,10) );	
																	
			//		var days = (e1_date - s1_date) / 1000 / 60 / 60 / 24; 		//1��=24�ð�*60��*60��*1000milliseconds
			//		var mons = (e1_date - s1_date) / 1000 / 60 / 60 / 24 / 30; 	//1��=24�ð�*60��*60��*1000milliseconds
			//	   	cal_dist  =      (    mons * toInt(fm.o_p_m.value)  ) + ( days * toInt(fm.o_p_d.value)  );/
			
			//	          var diff1_date = e1_date.getTime() - s1_date.getTime();
			//	 	count1 = Math.floor(diff1_date/(24*60*60*1000));			
			//		cal_dist =   	 Math.floor(parseDigit(fm.agree_dist.value))  * count1/ 365;
			//	} else {		
										  
			//		cal_dist =   	toInt(parseDigit(fm.agree_dist.value))  * toInt(parseDigit(fm.rent_days.value))   / 365;
					cal_dist =   	 Math.floor(parseDigit(fm.agree_dist.value))  *Math.floor(parseDigit(fm.rent_days.value))   / 365;
					
			//		cal_dist  =      (    toInt(fm.r_mon.value) * toInt(fm.o_p_m.value)  ) + (  toInt(fm.r_day.value) * toInt(fm.o_p_d.value)  );				
			//	}         	
								
				fm.cal_dist.value 		=     parseDecimal( Math.round(cal_dist)  );	
			
			//	fm.first_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value))   );	
					
				fm.last_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value))   );	
				fm.real_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value)) -   toInt(parseDigit(fm.first_dist.value))     );		  
				fm.over_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.real_dist.value)) -   toInt(parseDigit(fm.cal_dist.value))     );											
			//	fm.add_dist.value 		=     parseDecimal( 1000  );  //��񽺸��ϸ���				
			//	fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );
				
			//����� 20220414 ���ĸ� ȯ��
				if (  <%=base.getRent_dt()%>  > 20220414 ) {  
					// 2022-05 ����  over_dist��  0 ���� ũ�� 1000, 0  ������ -1000 ó�� - �⺻����ó���� 
					if ( -1000 <= toInt(parseDigit(fm.over_dist.value)) &&  toInt(parseDigit(fm.over_dist.value)) <= 1000  ) {
							fm.add_dist.value 		=  '0';  //�⺻����ó�� 
							fm.jung_dist.value 		=  '0';			
					} else {
							// 2022-05 ����  over_dist��  0 ���� ũ�� 1000, 0  ������ -1000 ó�� - �⺻����ó���� 
							if (toInt(parseDigit(fm.over_dist.value)) >= 0  ) {
								fm.add_dist.value 		=     parseDecimal( 1000  );  //�⺻����ó�� 			
							} else {
								fm.add_dist.value 		=     parseDecimal( -1000  );  //�⺻����ó�� 	
							}
							fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) - toInt(parseDigit(fm.add_dist.value))     );
					}
				} else {
					fm.add_dist.value 		=     parseDecimal( 1000  );  //��񽺸��ϸ���	(�����ΰ�� �����Ⱓ ǥ��)
					fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );					
				}
											
				//	alert(		toInt(parseDigit(fm.jung_dist.value))  );
				if ( 	toInt(parseDigit(fm.jung_dist.value))   > 0   ) {
					fm.r_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );								
					fm.j_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );
					
				}  else if ( toInt(parseDigit(fm.jung_dist.value))  == 0   ) {				    
					fm.r_over_amt.value 	=      "0";				
					fm.j_over_amt.value 	=     "0";	
					
				}  else  {	
				
				    fm.r_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.rtn_run_amt.value)   );								
					fm.j_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.rtn_run_amt.value)   );
							
			 	}								
			}		
		} //��ุ��, �ߵ����� 
				
		//���Կɼ��� ��� - 50% ������ ��츸 �ش�  (�Ϲݽ�, �⺻���� 100%���� )  : 202204���� 40% ���� �Ǵ� ȯ��
		if ( fm.cls_st.value == '8'   ) { 
		  		   	     
			if ( (  <%=base.getRent_dt()%>  > 20130604  &&    <%=car1.getAgree_dist()%>  > 0   &&  <%=base.getCar_gu()%>  ==  '1' ) ||    (  <%=base.getRent_dt()%>  > 20140705  &&  <%=base.getCar_gu()%>  ==  '0' )   ) {  
			
				 // fm.taecha_st_dt ���� �ִٸ� �����Ī - 20210330 ������ ���� �ʰ�����뿩�� �������� ���� - ���� �����Ī�� ��� ������ �ʰ�����δ�� �������� ó�� 
			//	if ( fm.taecha_st_dt.value  != "" )  {			
			//		var s1_str = fm.taecha_st_dt.value; 
			//		var e1_str = fm.cls_dt.value;
			//		var  count1 = 0;
					  
			//		var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );								
			//		var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1,  e1_str.substring(8,10) );	
																	
			//		var days = (e1_date - s1_date) / 1000 / 60 / 60 / 24; 		//1��=24�ð�*60��*60��*1000milliseconds
			//		var mons = (e1_date - s1_date) / 1000 / 60 / 60 / 24 / 30; 	//1��=24�ð�*60��*60��*1000milliseconds
			//	         	cal_dist  =      (    mons * toInt(fm.o_p_m.value)  ) + ( days * toInt(fm.o_p_d.value)  );/
			
			//	   var diff1_date = e1_date.getTime() - s1_date.getTime();
			//	 	count1 = Math.floor(diff1_date/(24*60*60*1000));
			//		cal_dist =   	toInt(fm.agree_dist.value) * count1/ 365;
			//	} else {				  
				//	cal_dist =   	toInt(parseDigit(fm.agree_dist.value))  * toInt(parseDigit(fm.rent_days.value))   / 365;
					cal_dist =   	 Math.floor(parseDigit(fm.agree_dist.value))  *Math.floor(parseDigit(fm.rent_days.value))   / 365;
			//		cal_dist  =      (    toInt(fm.r_mon.value) * toInt(fm.o_p_m.value)  ) + (  toInt(fm.r_day.value) * toInt(fm.o_p_d.value)  );				
			//	}         	
				
				fm.cal_dist.value 		=     parseDecimal( cal_dist   );	
			
			//	fm.first_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value))   );	
					
				fm.last_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value))   );	
				fm.real_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value)) -   toInt(parseDigit(fm.first_dist.value))     );		  
				fm.over_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.real_dist.value)) -   toInt(parseDigit(fm.cal_dist.value))     );								
			//	fm.add_dist.value 		=     parseDecimal( 1000  );  //��񽺸��ϸ���
			//	fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );
				
			  	if (  <%=base.getRent_dt()%>  > 20220414 ) {  //����� 20220414 ���ĸ� ȯ��
					if ( -1000 <= toInt(parseDigit(fm.over_dist.value)) &&  toInt(parseDigit(fm.over_dist.value)) <= 1000  ) {
						fm.add_dist.value 		=  '0';  //�⺻����ó�� 
						fm.jung_dist.value 		=  '0';			
					} else {
						// 2022-05 ����  over_dist��  0 ���� ũ�� 1000, 0  ������ -1000 ó�� - �⺻����ó���� 
						if (toInt(parseDigit(fm.over_dist.value)) >= 0  ) {
							fm.add_dist.value 		=     parseDecimal( 1000  );  //�⺻����ó�� 			
						} else {
							fm.add_dist.value 		=     parseDecimal( -1000  );  //�⺻����ó�� 	
						}
						fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) - toInt(parseDigit(fm.add_dist.value))     );
					}
			    } else {
			    	fm.add_dist.value 		=     parseDecimal( 1000  );  //��񽺸��ϸ���	(�����ΰ�� �����Ⱓ ǥ��)
					fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );	
			    }
			  								
				//�⺻�� 100% ����,  //�Ϲݽĸ� ��� 
				<%    if ( fee.getRent_way().equals("1") )  { %>
							
					   if ( toInt(parseDigit(fm.jung_dist.value))   > 0   ) {
					   		
							fm.r_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );
							
							if (  <%=base.getRent_dt()%>  > 20220414 ) {
								fm.m_over_amt.value 	=     parseDecimal(   toInt(parseDigit(fm.r_over_amt.value)) * 0.6 );	
								fm.m_reason.value        =   "���Կɼ� 60% ����";
							} else {
								fm.m_over_amt.value 	=     parseDecimal(   toInt(parseDigit(fm.r_over_amt.value)) * 0.5 );	
								fm.m_reason.value       =   "���Կɼ� 50% ����";
							}
							
							fm.j_over_amt.value 	=      parseDecimal(  toInt(parseDigit(fm.r_over_amt.value)) -   toInt(parseDigit(fm.m_over_amt.value))    );	 //����
												
						}  else if ( toInt(parseDigit(fm.jung_dist.value))  == 0   ) {				    
							fm.r_over_amt.value 	=      "0";				
							fm.j_over_amt.value 	=     "0";	
								
						}  else  {	
							
							if (  <%=base.getRent_dt()%>  > 20220414 ) {  //����� 20220414 ���ĸ� ȯ��
								fm.r_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.rtn_run_amt.value)   );				
								fm.m_over_amt.value 	=     parseDecimal(   toInt(parseDigit(fm.r_over_amt.value)) * 0.6  );	
								fm.m_reason.value       =   "���Կɼ� 40% ȯ��";	
								fm.j_over_amt.value 	=      parseDecimal(  toInt(parseDigit(fm.r_over_amt.value)) -   toInt(parseDigit(fm.m_over_amt.value))   );	 //ȯ��
							
							} else {
								fm.r_over_amt.value 	=      "0";				
								fm.j_over_amt.value 	=     "0";	
															
							}     
							
						}							
					 
				<% } else { %> 
						fm.r_over_amt.value 	=      "0";				
						fm.j_over_amt.value 	=     "0";	
						fm.m_reason.value       =   "���Կɼ� �⺻�� ����";	
				<% }	%>
				
			   
			}
		}
					
		//	if ( 	toInt(parseDigit(fm.jung_dist.value))   > 0 ) {
		//		fm.r_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );	
		//	}  else {
		//		fm.r_over_amt.value 	=      "0";
		//	}
//-->
</script>
</body>
</html>
