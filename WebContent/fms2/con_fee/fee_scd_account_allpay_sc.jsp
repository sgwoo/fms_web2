<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.fee.*, acar.car_mst.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String t_wd1 	= request.getParameter("t_wd1")==null?"":request.getParameter("t_wd1");
	String t_wd2 	= request.getParameter("t_wd2")==null?"":request.getParameter("t_wd2");
	String t_wd3 	= request.getParameter("t_wd3")==null?"":request.getParameter("t_wd3");
	String t_wd4 	= request.getParameter("t_wd4")==null?"":request.getParameter("t_wd4");
	
	String print_yn 	= request.getParameter("print_yn")==null?"":request.getParameter("print_yn");

	int total_amt1 = 0;
	int total_amt2 = 0;
	int total_amt3 = 0;
	int total_amt4 = 0;
	
	int s_s = 0;
	
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
//-->
</script>
<style type-"text/css>
<!--	
input.whitetext13b		{ text-align:left; font-size : 13pt; background-color:#ffffff; border-color:##ffffff; border-width:0; color:#303030;  font-weight:bold;}
input.whitenumber13b	{ text-align:right; font-size : 13pt; background-color:#ffffff; border-color:##ffffff; border-width:0; color:#303030;  font-weight:bold;}
//-->
</style>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' target='' method="post">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<%if(t_wd1.equals("")||t_wd2.equals("")||t_wd3.equals("")||t_wd4.equals("")){%>
	<input type='hidden' name='t_amt' value='0'>
	<tr>
	    <td align="center"> * ������ �����Ͻð� �˻��Ͻʽÿ�.</td>
	</tr>		
	<%}else{
		
		//�Ǻ� �뿩�� ������ ���
		Hashtable fee_stat = af_db.getFeeScdStatPrint2(m_id, l_cd);
		
		s_s = AddUtil.parseInt(String.valueOf(fee_stat.get("DT")))-AddUtil.parseInt(String.valueOf(fee_stat.get("DT2")));
				
		//�뿩�� ������
		Vector fee_scd = af_db.getFeeScdPrint2(l_cd, "", false);
		int fee_scd_size = fee_scd.size();	
		
		int dly_scd_yn = 0;
		
		FeeScdBean s_fee_scd = new FeeScdBean();
		for(int i = 0 ; i < fee_scd_size ; i++){
			FeeScdBean a_fee = (FeeScdBean)fee_scd.elementAt(i);
			if(AddUtil.parseInt(t_wd1)<=AddUtil.parseInt(a_fee.getFee_tm()) && AddUtil.parseInt(t_wd2)>=AddUtil.parseInt(a_fee.getFee_tm()) && a_fee.getRc_yn().equals("0")){ //���Ա�
				if(a_fee.getFee_tm().equals(t_wd1)){
					s_fee_scd = a_fee;
				}
				if(AddUtil.parseInt(AddUtil.replace(t_wd4,"-",""))>=AddUtil.parseInt(AddUtil.replace(a_fee.getR_fee_est_dt(),"-","")) || !a_fee.getDly_days().equals("0")){
					dly_scd_yn++;
					if(!a_fee.getDly_days().equals("0") && a_fee.getDly_fee() >0){
						s_s = s_s-a_fee.getDly_fee();
					}
				}
			}
		}
		
		//�⺻����
		Hashtable fee = af_db.getFeebaseNew(m_id, l_cd);
		
		//���ʴ뿩����
		ContFeeBean f_fee = a_db.getContFeeNew(m_id, l_cd, s_fee_scd.getRent_st());
		
		//�������뿩����
		ContFeeBean max_fee = a_db.getContFeeNew(m_id, l_cd, s_fee_scd.getRent_st());
		
		//�ڵ���ȸ��&����&�ڵ�����
		AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
		CarMstBean mst = a_cmb.getCarEtcNmCase(m_id, l_cd);
		

		
	%>
	<tr>
	  <td colspan='2'><img src="/acar/images/logo_1.png" style="margin-left: 30px;"></td>
	</tr>
	<tr> 
  	<td colspan='2' style="font-size : 15pt;" align='center'><span class=style2>�뿩�� �Ͻó� ���</span></td>	
	</tr>
	<tr>
	  <td colspan='2' align="center">&nbsp;</td>
	</tr>
	<tr>
	  <td colspan='2' class=line2></td>
	</tr>
  <tr> 
    <td colspan='2' class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td width='10%' class='title' >����ȣ</td>
                                <td width='15%'>&nbsp;<%=fee.get("RENT_L_CD")%></td>
                                <td width='10%' class='title' >��ȣ</td>
                                <td colspan='3'>&nbsp;<%=fee.get("FIRM_NM")%></td>
                                <td width='10%' class='title' >����</td>
                                <td width='15%'>&nbsp;<%=fee.get("CLIENT_NM")%></td>
                            </tr>
                            <tr> 
                                <td class='title' >������ȣ</td>
                                <td>&nbsp;<%=fee.get("CAR_NO")%></td>
                                <td class='title' >����</td>
                                <td colspan='3'>&nbsp;<%=mst.getCar_nm()+" "+mst.getCar_name()%></td>
                                <td class='title' >�뿩���</td>
                                <td> 
                                <%if(max_fee.getRent_way().equals("1")){%>
                                &nbsp;�Ϲݽ� 
                                <%}else if(max_fee.getRent_way().equals("2")){%>
                                &nbsp;����� 
                                <%}else{%>
                                &nbsp;�⺻�� 
                                <%}%>
                                </td>
                            </tr>
                            <tr> 
                                <td class='title' >ä������</td>
                                <td>&nbsp;<%=fee.get("GI_ST")%></td>
                                <td class='title' > �뿩�Ⱓ </td>
                                <td>&nbsp;<%=f_fee.getCon_mon()%>����</td>
                                <td width='10%' class='title' > ������ </td>
                                <td width='15%'>&nbsp;<%=AddUtil.ChangeDate2(f_fee.getRent_start_dt())%></td>
                                <td class='title' > ������ </td>
                                <td>&nbsp;<%=AddUtil.ChangeDate2(f_fee.getRent_end_dt())%></td>
                            </tr>                            	
                            <tr> 
                                <td class='title' > ������ </td>
                                <td>&nbsp;<%=Util.parseDecimal(f_fee.getPp_s_amt()+f_fee.getPp_v_amt())%>��
                                	<%if(f_fee.getPp_chk().equals("0")){%><br>&nbsp;�ſ��յ����<%}%>
                                </td>
                                <td class='title' > ������ </td>
                                <td>&nbsp;<%=Util.parseDecimal(f_fee.getGrt_amt_s())%>��&nbsp;</td>
                                <td class='title' >���ô뿩��</td>
                                <td>&nbsp;<%=Util.parseDecimal(f_fee.getIfee_s_amt()+f_fee.getIfee_v_amt())%>��</td>
                                <td class='title' >���뿩��</td>
                                <td>&nbsp;<%=Util.parseDecimal(f_fee.getFee_s_amt()+f_fee.getFee_v_amt())%>��
                                <%if(f_fee.getFee_chk().equals("1")){%><br>&nbsp;�Ͻÿϳ�<%}%>	
                                </td>
                            </tr>
                        </table>
    </td>
  </tr>
  <tr>
    <td colspan='2'>&nbsp;</td>
  </tr>
	<tr>
	  <td colspan='2' class=line2></td>
	</tr>
  <tr> 
    <td colspan='2' class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td width='25%' class='title' >���ο�����<br>(���簡ġ ��� ������)</td>
                                <td width='25%' align='center'><input type='text' name='t_wd4' size='13' class='whitetext13b' value='<%=AddUtil.ChangeDate2(t_wd4)%>' readonly></td>
                                <td width='25%' class='title' >������ ȸ��</td>
                                <td width='25%' align='center'>�ϴ�����</td>
                            </tr>
                            <tr> 
                                <td class='title' >���Բ��� ������ �Ѿ�<br>(VAT����)</td>
                                <td align='center' style="font-size : 13pt;"><input type='text' name='t_amt' size='12' class='whitenumber13b' value='' readonly>��
                                <td colspan='2' align='center'>���뿩�� ���簡ġ �հ�<%if(dly_scd_yn>0){%> + �̳��뿩��(��ü�� ����) <%}%>
                                </td>
                            </tr>
                        </table>
    </td>
  </tr>
  <tr> 
    <td colspan='2' class=h></td>
  </tr>
  <tr> 
    <td width='70%'>�� �̵��� �뿩�� ���簡ġ ��� </td>	
    <td width='30%' align='right'>VAT����</td>	
	</tr>
	<tr>
	  <td colspan='2' class=line2></td>
	</tr>
  <tr> 
    <td colspan='2' class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='5%' class='title'>ȸ��</td>
                    <td width='12%' class='title'>����</td>
                    <td width='12%' class='title'>�� �Աݿ�����</td>
                    <td width='12%' class='title'>���뿩��</td>
                    <td width='12%' class='title'>���ο�����</td>
                    <td width='18%' class='title'>���뿩�� ���簡ġ</td>
                    <td width='12%' class='title'>���簡ġ��</td>
                    <td width='17%' class='title'>���� �ϼ�</td>
                </tr>
                <tr> 
            <td align='center'>&nbsp;</td>
            <td align='center'>&nbsp;</td>
            <td align='center'>(1)</td>
            <td align='center'>(2)</td>
            <td align='center'>(3)</td>
            <td align='center'>(4)=(2)��(5)</td>
            <td align='center'>(5)</td>
            <td align='center'>(6)=(1)-(3)</td>
                </tr>                
                <%		for(int i = 0 ; i < fee_scd_size ; i++){
												FeeScdBean a_fee = (FeeScdBean)fee_scd.elementAt(i);
												if(AddUtil.parseInt(AddUtil.replace(t_wd4,"-",""))<AddUtil.parseInt(AddUtil.replace(a_fee.getR_fee_est_dt(),"-","")) && AddUtil.parseInt(t_wd1)<=AddUtil.parseInt(a_fee.getFee_tm()) && AddUtil.parseInt(t_wd2)>=AddUtil.parseInt(a_fee.getFee_tm()) && a_fee.getRc_yn().equals("0") && a_fee.getDly_days().equals("0")){
													int prepay_day = AddUtil.parseInt(rs_db.getDay(t_wd4, a_fee.getR_fee_est_dt()))-1;
													double d_t_wd3 = AddUtil.parseDouble(t_wd3)/100;
													double d_prepay_day = AddUtil.parseDouble(String.valueOf(prepay_day));
													double d_fee_per = 1/Math.pow(1+d_t_wd3/12,d_prepay_day/365*12);
													float f_fee_per = Math.round(AddUtil.parseFloat(String.valueOf(d_fee_per))*10000)/100f;
													double d_now_value_amt = (a_fee.getFee_s_amt()+a_fee.getFee_v_amt())*d_fee_per;
													int i_now_value_amt = AddUtil.parseInt(AddUtil.parseFloatRoundZero(String.valueOf(d_now_value_amt)));
													total_amt1 = total_amt1 + a_fee.getFee_s_amt()+a_fee.getFee_v_amt();
													total_amt2 = total_amt2 + i_now_value_amt;
								%>
                <tr> 
            <td align='center'><%=a_fee.getFee_tm()%></td>
            <td align='center'>�뿩��</td>
            <td align='center'><%=AddUtil.ChangeDate2(a_fee.getFee_est_dt())%></td>
            <td align='right'><%=AddUtil.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%>��</td>
            <td align='center'><%=AddUtil.ChangeDate2(t_wd4)%></td>
            <td align='right'><%=AddUtil.parseDecimal(i_now_value_amt)%>��</td>
            <td align='right'><%=AddUtil.parseFloatCipher(String.valueOf(f_fee_per),2)%>%</td>
            <td align='right'><%=prepay_day%></td>
                </tr>
                <%			}%>
                <%		}%>
                <tr> 
                    <td colspan='3' class='title'>�հ�</td>
                    <td align='right'><%=AddUtil.parseDecimal(total_amt1)%>��</td>
                    <td align='center'>-</td>
                    <td class='title' style='font-size : 10pt;text-align:right;'><%=AddUtil.parseDecimal(total_amt2)%>��</td>
                    <td colspan='2' class='title' style="font-size : 8pt;">�� ���� �ݾ״�� <%=AddUtil.parseFloatCipher(String.valueOf(Math.round(AddUtil.parseFloat(String.valueOf(total_amt2))/AddUtil.parseFloat(String.valueOf(total_amt1))*10000)/100f),1)%>%(<%=AddUtil.parseDecimal(total_amt2-total_amt1)%>��)</td>
                </tr>                
                        </table>
    </td>
  </tr>	
  <tr> 
    <td colspan='2'>�� �����Ͽ� ���� �̵��� �뿩���� ���簡ġ�� �����˴ϴ�.</td>
	</tr>
                <%if(dly_scd_yn>0){%>
  <tr> 
    <td colspan='2' class=h></td>
  </tr>       
  <tr> 
    <td colspan='2'>�� �̳� �뿩�� (���ο����� ����, ��ü�� ����) </td>	
	</tr>
	<tr>
	  <td colspan='2' class=line2></td>
	</tr>
  <tr> 
    <td colspan='2' class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='5%' class='title'>ȸ��</td>
                    <td width='12%' class='title'>����</td>
                    <td width='12%' class='title'>�� �Աݿ�����</td>
                    <td width='12%' class='title'>���뿩��<br>(VAT����)</td>
                    <td width='12%' class='title'>���ο�����</td>
                    <td width='18%' class='title'>���Աݾ�</td>
                    <td width='12%' class='title'>��ü�ϼ�</td>
                    <td width='17%' class='title'>��ü��</td>
                </tr>
                <%if(s_s>0){%>
                <tr> 
            <td align='center'>-</td>
            <td align='center'>�̳���ü��</td>
            <td align='center'>-</td>
            <td align='center'>-</td>
            <td align='center'>-</td>
            <td align='center'>-</td>
            <td align='center'>-</td>
            <td align='right'><%=AddUtil.parseDecimal(s_s)%>��</td>
                </tr>                
                <%}%>
                <%		for(int i = 0 ; i < fee_scd_size ; i++){
												FeeScdBean a_fee = (FeeScdBean)fee_scd.elementAt(i);
												if(AddUtil.parseInt(t_wd1)<=AddUtil.parseInt(a_fee.getFee_tm()) && AddUtil.parseInt(t_wd2)>=AddUtil.parseInt(a_fee.getFee_tm()) && a_fee.getRc_yn().equals("0") && (AddUtil.parseInt(AddUtil.replace(t_wd4,"-",""))>=AddUtil.parseInt(AddUtil.replace(a_fee.getR_fee_est_dt(),"-","")) || !a_fee.getDly_days().equals("0"))){
													int i_dly_day = AddUtil.parseInt(rs_db.getDay(a_fee.getR_fee_est_dt(), t_wd4))-1;
													double d_dly_amt = (a_fee.getFee_s_amt()+a_fee.getFee_v_amt())*0.24/365*i_dly_day;
													int i_dly_amt = AddUtil.parseInt(AddUtil.parseFloatRoundZero(String.valueOf(d_dly_amt)));
													total_amt3 = total_amt3 + a_fee.getFee_s_amt()+a_fee.getFee_v_amt();
													total_amt4 = total_amt4 + i_dly_amt;
								%>
                <tr> 
            <td align='center'><%=a_fee.getFee_tm()%></td>
            <td align='center'><%if(a_fee.getTm_st1().equals("0")){%>�뿩��<%}else{%>�ܾ�<%}%></td>
            <td align='center'><%=AddUtil.ChangeDate2(a_fee.getFee_est_dt())%></td>
            <td align='right'><%=AddUtil.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%>��</td>
            <td align='center'><%=AddUtil.ChangeDate2(t_wd4)%></td>
            <td align='right'>0</td>
            <td align='right'><%=i_dly_day%>��</td>
            <td align='right'><%=AddUtil.parseDecimal(i_dly_amt)%>��</td>
                </tr>
                <%			}%>
                <%		}%>
                <tr> 
                    <td colspan='3' align='center'>�հ�</td>
                    <td align='right'><%=AddUtil.parseDecimal(total_amt3)%>��</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>                                        
                    <td align='right'><%=AddUtil.parseDecimal(total_amt4+s_s)%>��</td>
                </tr>                
                        </table>
    </td>
  </tr>		
  <tr>
    <td colspan='2' class=h></td>
  </tr>   
  <tr> 
    <td colspan='2'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='41%' class='line'>
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='70%' align='center'>�̳��뿩��(A)</td>
                    <td width='30%' align='right'><%=AddUtil.parseDecimal(total_amt3)%>��</td>
                </tr>	
                <tr> 
                    <td align='center'>���� ������ ���� ��ü��(B)</td>
                    <td align='right'><%=AddUtil.parseDecimal(total_amt4+s_s)%>��</td>
                </tr>	
                <tr> 
                    <td class='title'>�հ�[(A)+(B)]</td>
                    <td class='title' style='font-size : 10pt;text-align:right;'><%=AddUtil.parseDecimal(total_amt3+total_amt4+s_s)%>��</td>
                </tr>	
                  </table>	
                    </td>
                    <td width='59%'>&nbsp;</td>
                </tr>    
                        </table>
    </td>
  </tr>		
                <%}%>           
  <tr>
    <td colspan='2'>&nbsp;</td>
  </tr>                   
	<tr> 
  	<td colspan='2' style="font-size : 15pt;font-family:����ü;" align='center'><span class=style2>�ֽ�ȸ�� �Ƹ���ī ��ǥ�̻� ������</span></td>	
	</tr>                                     
	<%}%>
</table>
<script language='javascript'>
<!--
	var fm = document.form1;	
	fm.t_amt.value = parseDecimal(<%=total_amt2+total_amt3+total_amt4+s_s%>);
	
	<%if(print_yn.equals("Y")){%>
		window.print();
	<%}%>
//-->
</script>
</body>
</html>


