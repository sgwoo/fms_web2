<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=fee_scd_excel.xls");
%>
<%//@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, acar.cls.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">

</head>
<body>
<%
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String b_dt 	= request.getParameter("b_dt")==null?"":request.getParameter("b_dt");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String bill_yn 	= request.getParameter("bill_yn")==null?"":request.getParameter("bill_yn");
	String cls_chk 	= request.getParameter("cls_chk")==null?"N":request.getParameter("cls_chk");
	
	//�⺻����
	Hashtable fee = af_db.getFeebaseNew(m_id, l_cd);
	
	//���ʴ뿩����
	ContFeeBean f_fee = a_db.getContFeeNew(m_id, l_cd, "1");
	
	//��������
	ClsBean cls = as_db.getClsCase(m_id, l_cd);
	
	//�Ǻ� �뿩�� ������ ����Ʈ
	Vector fee_scd = af_db.getFeeScdNew2(m_id, l_cd, b_dt, mode, bill_yn, false);
	int fee_scd_size = fee_scd.size();
	//������ 2018.04.16
	Vector fee_scd_sun_nap = af_db.getFeeScdNew2(m_id, l_cd, b_dt, mode, bill_yn, true);
	int fee_scd_sun_nap_size = fee_scd_sun_nap.size();
	
	int nc = 0;
	int ns = 0;
	int nv = 0;
	int rc = 0;
	int rs = 0;
	int rv = 0;
	int mc = 0;
	int ms = 0;
	int mv = 0;
	int dc = 0;
	int dt = 0;
	int dt2 = 0;
	
	//�Ǻ� �뿩�� ������ ���
	Hashtable fee_stat = af_db.getFeeScdStatNew(m_id, l_cd, b_dt, mode, bill_yn);
	int fee_stat_size = fee_stat.size();
	
	//��ü�� ���� ������ ����Ʈ
	Vector fee_scd2 = af_db.getFeeDlyScd(m_id, l_cd);
	int fee_scd_size2 = fee_scd2.size();	
%>
  <table border="0" cellspacing="0" cellpadding="0" width=655>
    <tr>
	  <td>
	    <table width="645">
          <tr>
            <td width="400"> <font color="red"> �뿩�� ������ ��ȸ �� ���� </font> </td>
            <td align="right"></a> 
            </td>		  
		  </tr>		
	    </table>  
	  </td> 
    </tr>
    <tr> 
      <td colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=655>
          <tr> 
            <td class='line'> 
              <table border="1" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td colspan="2" width='10%' class='title' style="font-size : 8pt;">����ȣ</td>
                  <td width='17%'>&nbsp;<%=fee.get("RENT_L_CD")%></td>
                  <td colspan="2" width='10%' class='title' style="font-size : 8pt;">��ȣ</td>
                  <td  colspan="3">&nbsp;<%=fee.get("FIRM_NM")%></td>
                  <td colspan="2" width='10%' class='title' style="font-size : 8pt;">����</td>
                  <td width='17%'>&nbsp;<%=fee.get("CLIENT_NM")%></td>
                </tr>
                <tr> 
                  <td colspan="2" class='title' style="font-size : 8pt;">������ȣ</td>
                  <td>&nbsp;<font color="#000099"><b><%=fee.get("CAR_NO")%></b></font></td>
                  <td colspan="2" class='title' style="font-size : 8pt;">����</td>
                  <td colspan="3">&nbsp;<%=fee.get("CAR_NM")%></td>
                  <td colspan="2" class='title' style="font-size : 8pt;">�뿩���</td>
                  <td>&nbsp;<%if(fee.get("RENT_WAY").equals("1")){%>
                    �Ϲݽ� 
                    <%}else if(fee.get("RENT_WAY").equals("2")){%>
                    ����� 
                    <%}else{%>
                    �⺻�� 
                    <%}%></td>
                </tr>
                <tr> 
                  <td colspan="2" class='title' style="font-size : 8pt;">ä������</td>
                  <td>&nbsp;<%=fee.get("GI_ST")%></td>
                  <td colspan="2" class='title' style="font-size : 8pt;">�뿩�Ⱓ</td>
                  <td>&nbsp;<%=f_fee.getCon_mon()%>����</td>
                  <td width='10%' class='title' style="font-size : 8pt;">������</td>
                  <td width='18%'>&nbsp;<%=AddUtil.ChangeDate2(f_fee.getRent_start_dt())%></td>
                  <td colspan="2" width='10%' class='title' style="font-size : 8pt;">������</td>
                  <td width='18%'>&nbsp;<%=AddUtil.ChangeDate2(f_fee.getRent_end_dt())%></td>
                </tr>
                <tr> 
                  <td colspan="2" class='title' style="font-size : 8pt;"> ������ </td>
                  <td>&nbsp;<%=Util.parseDecimal(f_fee.getPp_s_amt()+f_fee.getPp_v_amt())%>��&nbsp;</td>
                  <td colspan="2" class='title' style="font-size : 8pt;"> ������ </td>
                  <td>&nbsp;<%=Util.parseDecimal(f_fee.getGrt_amt_s())%>��&nbsp;</td>
                  <td class='title' style="font-size : 8pt;">���ô뿩��</td>
                  <td>&nbsp;<%=Util.parseDecimal(f_fee.getIfee_s_amt()+f_fee.getIfee_v_amt())%>��&nbsp;</td>
                  <td colspan="2" class='title' style="font-size : 8pt;">���뿩��</td>
                  <td>&nbsp;<%=Util.parseDecimal(f_fee.getFee_s_amt()+f_fee.getFee_v_amt())%>��&nbsp;</td>
                </tr>				
          	<%	String rent_st = String.valueOf(fee.get("RENT_ST"));
		  		for(int i=2; i<=AddUtil.parseInt(rent_st); i++){
					ContFeeBean ext_fee = a_db.getContFeeNew(m_id, l_cd, Integer.toString(i));
					if(!ext_fee.getCon_mon().equals("")){%>		
				<tr></tr>				
                <tr> 
                  <td colspan="2" class='title' style="font-size : 8pt;">��������</td>
                  <td>&nbsp;<%=AddUtil.ChangeDate2(ext_fee.getRent_start_dt())%></td>
                  <td colspan="2" class='title' style="font-size : 8pt;">�뿩�Ⱓ</td>
                  <td>&nbsp;<%=ext_fee.getCon_mon()%>����</td>
                  <td class='title' style="font-size : 8pt;">������</td>
                  <td>&nbsp;<%=AddUtil.ChangeDate2(ext_fee.getRent_start_dt())%></td>
                  <td colspan="2" class='title' style="font-size : 8pt;">������</td>
                  <td>&nbsp;<%=AddUtil.ChangeDate2(ext_fee.getRent_end_dt())%></td>
                </tr>
                <tr> 
                  <td colspan="2" class='title' style="font-size : 8pt;">������</td>
               	  <td>&nbsp;<%=Util.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%>��&nbsp;&nbsp;</td>
                  <td colspan="2" class='title' style="font-size : 8pt;">������</td>
                  <td>&nbsp;<%=Util.parseDecimal(ext_fee.getGrt_amt_s())%>��&nbsp;&nbsp;</td>
                  <td class='title' style="font-size : 8pt;">���ô뿩��</td>
                  <td>&nbsp;<%=Util.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>��</td>
                  <td colspan="2" class='title' style="font-size : 8pt;">���뿩��</td>
                  <td>&nbsp;<%=Util.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%>��&nbsp;</td>
                </tr>
          	<%		}
		  		}%>
              </table>
            </td>
          </tr>
    	</table>
	  </td>
  	</tr>
  </table>
  <table border="0" cellspacing="0" cellpadding="0" width=655>
    <tr> 
      <td width="400">[ �뿩�� ���� ������ ]</td>
      <td align='right' width="400">&nbsp;</td>
    </tr>
    <tr> 
      <td class=line colspan='2'> 
        <table border="1" cellspacing="1" cellpadding="0" width="665">
          <tr> 
            <td style="font-size : 8pt;" class='title' width="20">ȸ��</td>
            <!--<td style="font-size : 8pt;" class='title' width="40">����</td>-->
            <td style="font-size : 8pt;" class='title' width="110">���Ⱓ</td>
            <td style="font-size : 8pt;" class='title' width="60">�Աݿ�����</td>			
            <td style="font-size : 8pt;" class='title' width="75">���ް�</td>
            <td style="font-size : 8pt;" class='title' width="70">�ΰ���</td>
            <td style="font-size : 8pt;" class='title' width="75">���뿩��</td>
            <td style="font-size : 8pt;" class='title' width="60">�Ա�����</td>
            <td style="font-size : 8pt;" class='title' width="80">���Աݾ�</td>
            <td style="font-size : 8pt;" class='title' width="40">��ü<br>�ϼ�</td>
            <td style="font-size : 8pt;" class='title' width="55">��ü��</td>
            <td style="font-size : 8pt;" class='title' width="60">���ݰ�꼭<br>����</td>
          </tr>
          <%for(int i = 0 ; i < fee_scd_size ; i++){
				FeeScdBean a_fee = (FeeScdBean)fee_scd.elementAt(i);
				if(cls_chk.equals("Y") && !a_fee.getTm_st1().equals("0") && a_fee.getBill_yn().equals("N")) continue;
				//�뿩�����
				if(a_fee.getRc_amt()>0){//����
					rc ++;
					rs += Math.round(a_fee.getRc_amt()/1.1);
					rv += a_fee.getRc_amt()-(Math.round(a_fee.getRc_amt()/1.1));
				}else{
					if(a_fee.getDly_fee()==0){//�̵���
						mc ++;
						ms += a_fee.getFee_s_amt();
						mv += a_fee.getFee_v_amt();
					}else{
						nc ++;
						ns += a_fee.getFee_s_amt();
						nv += a_fee.getFee_v_amt();
					}
				}
				//��ü�����
				if(a_fee.getDly_fee()>0){
					dc ++;
					dt += a_fee.getDly_fee();
				}
				if(a_fee.getBill_yn().equals("Y") || a_fee.getRc_amt() >0){%>
          <tr> 
            <td style="font-size : 8pt;" align='center'><%=a_fee.getFee_tm()%></td>
            <!--<td style="font-size : 8pt;" align='center'><%if(a_fee.getTm_st1().equals("0")){%>�뿩��<%}else{%>�ܾ�<%}%></td>-->
            <td style="font-size : 8pt;" align='center'><%=a_fee.getUse_s_dt()%>~<%=a_fee.getUse_e_dt()%></td>
            <td style="font-size : 8pt;" align='center'><%=a_fee.getFee_est_dt()%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_s_amt())%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_v_amt())%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%></td>
			<%		if( cls_chk.equals("Y") && a_fee.getRc_dt().equals(AddUtil.replace(cls.getCls_dt(),"-","")) ){%>
            <td style="font-size : 8pt;" align='center'></td>
            <td style="font-size : 8pt;" align='center'>0</td>
            <td style="font-size : 8pt;" align='center'><%=a_fee.getDly_days()%>��</td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getDly_fee())%></td>
            <td style="font-size : 8pt;" align='center'><%=AddUtil.ChangeDate2(a_fee.getExt_dt())%></td>
			<%		}else{%>
            <td style="font-size : 8pt;" align='center'><%=a_fee.getRc_dt()%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getRc_amt())%></td>
            <td style="font-size : 8pt;" align='center'><%=a_fee.getDly_days()%>��</td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getDly_fee())%></td>			
            <td style="font-size : 8pt;" align='center'><%=AddUtil.ChangeDate2(a_fee.getExt_dt())%></td>
			<%		}%>
          </tr>
		  <%	}else{%>
          <tr> 
            <td style="font-size : 8pt;" align='center'><%=a_fee.getFee_tm()%></td>
            <!--<td style="font-size : 8pt;" align='center'><%if(a_fee.getTm_st1().equals("0")){%>�뿩��<%}else{%>�ܾ�<%}%></td>-->
            <td style="font-size : 8pt;" align='center'><%=a_fee.getUse_s_dt()%>~<%=a_fee.getUse_e_dt()%></td>
            <td style="font-size : 8pt;" align='center'><%=a_fee.getFee_est_dt()%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_s_amt())%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_v_amt())%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getFee_s_amt()+a_fee.getFee_v_amt())%></td>
            <td style="font-size : 8pt;" align='center'><%if(cls_chk.equals("Y")){%><%}else{%><%=AddUtil.replace(cls.getCls_dt(),"-","")%><%}%></td>
            <td style="font-size : 8pt;" align='right'><%if(cls_chk.equals("Y")){%>0<%}else{%>0<%}%></td>
            <td style="font-size : 8pt;" align='center'><%=a_fee.getDly_days()%>��</td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee.getDly_fee())%></td>
            <td style="font-size : 8pt;" align='center'><%=AddUtil.ChangeDate2(a_fee.getExt_dt())%></td>
          </tr>		  
		  <%	}%>
          <%}%>
        </table>
      </td>
      <td width='20'>&nbsp;</td>
    </tr>
  </table>
  <%if(fee_scd_sun_nap_size>0){%>
  <table border="0" cellspacing="0" cellpadding="0" width=655>
    <tr> 
      <td width="400">[ �����뿩��յ���� ������ ]</td>
      <td align='right' width="400">&nbsp;</td>
    </tr>
    <tr> 
      <td class=line colspan='2'> 
        <table border="1" cellspacing="1" cellpadding="0" width="665">
          <tr> 
            <td style="font-size : 8pt;" class='title' width="20">ȸ��</td>
            <td style="font-size : 8pt;" class='title' width="110">���Ⱓ</td>
            <td style="font-size : 8pt;" class='title' width="60">���ݰ�꼭����</td>			
            <td style="font-size : 8pt;" class='title' width="75">���ް�</td>
            <td style="font-size : 8pt;" class='title' width="70">�ΰ���</td>
            <td style="font-size : 8pt;" class='title' width="75">���뿩��</td>
            <td style="font-size : 8pt;" class='title' width="60">�Ա�����</td>
            <td style="font-size : 8pt;" class='title' width="80">���Աݾ�</td>
            <td style="font-size : 8pt;" class='title' width="40">��ü<br>�ϼ�</td>
            <td style="font-size : 8pt;" class='title' width="55">��ü��</td>
            <td style="font-size : 8pt;" class='title' width="60">���ݰ�꼭<br>��������</td>
          </tr>
          <%for(int j = 0 ; j < fee_scd_sun_nap_size ; j++){
				FeeScdBean a_fee_sn = (FeeScdBean)fee_scd_sun_nap.elementAt(j);
				if(!a_fee_sn.getTm_st1().equals("0") && a_fee_sn.getBill_yn().equals("N")) continue;
				if(a_fee_sn.getBill_yn().equals("Y") || a_fee_sn.getRc_amt() >0){%>
          <tr> 
            <td style="font-size : 8pt;" align='center'><%=a_fee_sn.getFee_tm()%></td>
            <td style="font-size : 8pt;" align='center'><%=a_fee_sn.getUse_s_dt()%>~<%=a_fee_sn.getUse_e_dt()%></td>
            <td style="font-size : 8pt;" align='center'><%=a_fee_sn.getTax_out_dt()%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee_sn.getFee_s_amt())%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee_sn.getFee_v_amt())%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee_sn.getFee_s_amt()+a_fee_sn.getFee_v_amt())%></td>
			<%		if(a_fee_sn.getRc_dt().equals(AddUtil.replace(cls.getCls_dt(),"-","")) ){%>
            <td style="font-size : 8pt;" align='center'></td>
            <td style="font-size : 8pt;" align='center'>0</td>
            <td style="font-size : 8pt;" align='center'><%=a_fee_sn.getDly_days()%>��</td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee_sn.getDly_fee())%></td>
            <td style="font-size : 8pt;" align='center'><%=AddUtil.ChangeDate2(a_fee_sn.getExt_dt())%></td>
			<%		}else{%>
            <td style="font-size : 8pt;" align='center'><%=a_fee_sn.getRc_dt()%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee_sn.getRc_amt())%></td>
            <td style="font-size : 8pt;" align='center'><%=a_fee_sn.getDly_days()%>��</td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee_sn.getDly_fee())%></td>	
            <td style="font-size : 8pt;" align='center'><%=AddUtil.ChangeDate2(a_fee_sn.getExt_dt())%></td>		
			<%		}%>
          </tr>
		  <%	}else{%>
          <tr> 
            <td style="font-size : 8pt;" align='center'><%=a_fee_sn.getFee_tm()%></td>
            <!--<td style="font-size : 8pt;" align='center'><%if(a_fee_sn.getTm_st1().equals("0")){%>�뿩��<%}else{%>�ܾ�<%}%></td>-->
            <td style="font-size : 8pt;" align='center'><%=a_fee_sn.getUse_s_dt()%>~<%=a_fee_sn.getUse_e_dt()%></td>
            <td style="font-size : 8pt;" align='center'><%=a_fee_sn.getFee_est_dt()%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee_sn.getFee_s_amt())%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee_sn.getFee_v_amt())%></td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee_sn.getFee_s_amt()+a_fee_sn.getFee_v_amt())%></td>
            <td style="font-size : 8pt;" align='center'><%=AddUtil.replace(cls.getCls_dt(),"-","")%></td>
            <td style="font-size : 8pt;" align='right'>0</td>
            <td style="font-size : 8pt;" align='center'><%=a_fee_sn.getDly_days()%>��</td>
            <td style="font-size : 8pt;" align='right'><%=Util.parseDecimal(a_fee_sn.getDly_fee())%></td>
            <td style="font-size : 8pt;" align='center'><%=AddUtil.ChangeDate2(a_fee_sn.getExt_dt())%></td>
          </tr>		  
		  <%	}%>
          <%}%>
        </table>
      </td>
      <td width='20'>&nbsp;</td>
    </tr>
  </table>
  <%}%>
  <%if(fee_stat_size > 0){%>
  <table border="0" cellspacing="0" cellpadding="0" width=655>
    <tr>
	  <td align='left'>[ �뿩�� ��� ]</td>
	</tr>
	<tr>
	  <td>
		<table width='645'>
          <tr>
			<td>
			  <table border="0" cellspacing="0" cellpadding="0" width=400>
                <tr>
				  <td class='line'>
					<table border="1" cellspacing="1" cellpadding="0" width=400>
                      <tr>
						<td class='title' width='60'>����</td>
						<td class='title' width='50'>�Ǽ�</td>
						<td class='title' width='100'>���ް�</td>
						<td class='title' width='90'>�ΰ���</td>
						<td class='title' width='100'>�հ�</td>
					  </tr>
					  <tr>
						<td class='title'> �̼��� </td>
						<td align='right'>
						  <%=Util.parseDecimal(nc)%></td>
						<td align='right'>
						  <%=Util.parseDecimal(ns)%></td>
						<td align='right'>
						  <%=Util.parseDecimal(nv)%></td>
						<td align='right'>
						  <%=Util.parseDecimal(ns+nv)%></td>
					  </tr>
					  <tr>
					    <td class='title'> ���� </td>
						<td align='right'>
						  <%=Util.parseDecimal(rc)%></td>
						<td align='right'>
						  <%=Util.parseDecimal(rs)%></td>
						<td align='right'>
						  <%=Util.parseDecimal(rv)%></td>
						<td align='right'>
						  <%=Util.parseDecimal(rs+rv)%></td>
					  </tr>
					  <tr>
						<td class='title'> �̵����� </td>
						<td align='right'>
						  <%=Util.parseDecimal(mc)%></td>
						<td align='right'>
						  <%=Util.parseDecimal(ms)%></td>
						<td align='right'>
						  <%=Util.parseDecimal(mv)%></td>
						<td align='right'>
						  <%=Util.parseDecimal(ms+mv)%></td>
					  </tr>										
					  <tr>
						<td class='title'> �հ� </td>
						<td align='right'>
						  <%=Util.parseDecimal(nc+rc+mc)%></td>
						<td align='right'>
						  <%=Util.parseDecimal(ns+rs+ms)%></td>
						<td align='right'>
						  <%=Util.parseDecimal(nv+rv+mv)%></td>
						<td align='right'>
						  <%=Util.parseDecimal(ns+rs+ms+nv+rv+mv)%></td>
					  </tr>
					</table>
				  </td>
				</tr>
			  </table>
			<td colspan="4" width='10'></td>
			<td width='170' valign='top'>
			  <table border="0" cellspacing="0" cellpadding="0" width=170>
				<tr>
				  <td class='line'>
					<table border="1" cellspacing="1" cellpadding="0" width=170>
                      <tr>
						<td class='title' width='70'> ��ü�Ǽ� </td>
						<td align='right' width="100"> 
                          <%=Util.parseDecimal(String.valueOf(fee_stat.get("DC")))%></td>
					  </tr>
					  <tr>											
                       	<td class='title'> �̼� ��ü��</td>
						<td align='right'>
						  <%=Util.parseDecimal(AddUtil.parseInt(String.valueOf(fee_stat.get("DT")))-AddUtil.parseInt(String.valueOf(fee_stat.get("DT2"))))%></td>
					  </tr>
					  <tr>											
                       	<td class='title'> ���� ��ü��</td>
						<td align='right'>
						  <%=Util.parseDecimal(String.valueOf(fee_stat.get("DT2")))%></td>
					  </tr>
					  <tr>											
                       	<td class='title'> �ѿ�ü��</td>
						<td align='right'>
						  <%=Util.parseDecimal(String.valueOf(fee_stat.get("DT")))%></td>
					  </tr>		
					</table>								
				  </td>
				</tr>
		  		<tr>
		          <td align="right">&nbsp;</td>
		  		</tr>				
			  </table>
			</td>
		  </tr>
		</table>
	  </td>
	</tr>
  </table>
  <%
  long total_amt 	= 0;%>    
  <table border="0" cellspacing="0" cellpadding="0" width=655>  
    <tr>
	  <td align='left'>[ ��ü�� ���ݰ��� ]</td>
	</tr>
    <tr> 
        <td class='line'> 
            <table border="1" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='7%'> ����</td>
                    <td class='title' width='19%'> ����ȣ</td>					
                    <td class='title' width="15%">�Ա�����</td>
                    <td class='title' width='18%'>�Աݾ�</td>
                    <td class='title'>���</td>
                </tr>
    		    <%for(int i = 0 ; i < fee_scd_size2 ; i++){
    				FeeDlyScdBean a_fee = (FeeDlyScdBean)fee_scd2.elementAt(i);%>				  
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=a_fee.getRent_l_cd()%></td>					
                    <td align="center"><%=a_fee.getPay_dt()%></td>
                    <td align="center"><%=Util.parseDecimal(a_fee.getPay_amt())%>��</td>
                    <td>&nbsp;<%=a_fee.getEtc()%></td>
                </tr>
    		    <%		total_amt 	= total_amt + Long.parseLong(String.valueOf(a_fee.getPay_amt()));
					}%>		
                <tr> 
                    <td class="title" colspan="3">�հ�</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>&nbsp;��&nbsp;</td>
                    <td class="title">&nbsp;</td>
                </tr>	
  
  <%	}else{%>
  <table border="0" cellspacing="0" cellpadding="0" width=655>
    <tr>
	  <td>
		�뿩�� ��谡 �����ϴ�
	  </td>
	</tr>
  </table>	
  <%	}%>
</body>
</html>
