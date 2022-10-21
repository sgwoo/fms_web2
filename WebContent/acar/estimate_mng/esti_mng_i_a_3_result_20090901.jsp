<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String est_code		= request.getParameter("est_code")	==null?"":request.getParameter("est_code");
	String reg_code		= request.getParameter("reg_code")	==null?"":request.getParameter("reg_code");
	String car_gu		= request.getParameter("car_gu")	==null?"":request.getParameter("car_gu");
	String rent_st		= request.getParameter("rent_st")	==null?"":request.getParameter("rent_st");
	String esti_table	= request.getParameter("esti_table")	==null?"":request.getParameter("esti_table");
	String car_mng_id	= request.getParameter("car_mng_id")	==null?"":request.getParameter("car_mng_id");
	
	
	if(!est_code.equals("") && reg_code.equals(""))	reg_code = est_code;
	
	if(esti_table.equals("")) esti_table = "estimate_hp";
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	
	out.println("#### reg_code="+reg_code+"-------------------------------<br>");
	
	Vector vt = e_db.getEstiMateRegCodeList(reg_code, esti_table, car_mng_id);
	int vt_size = vt.size();
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript">
<!--
	//���񱳺���
	function go_esti_print(t_st, est_id, car_gu){  
		var fm = document.form1;
		var SUBWIN = '';
		
		if(t_st == 'estimate_sh' || car_gu == '0'){	
			<%if(esti_table.equals("estimate")){%>
			SUBWIN="/acar/secondhand_hp/estimate_fms.jsp?from_page=/acar/estimate_mng/esti_mng_u.jsp&est_id="+est_id+"&acar_id=<%=ck_acar_id%>";					
			<%}else{%>	
			SUBWIN="/acar/secondhand_hp/estimate.jsp?est_id="+est_id+"&acar_id=<%=ck_acar_id%>";					
			<%}%>
		}else{
			if(t_st == 'estimate' && car_gu == '�������'){
				SUBWIN="/acar/secondhand_hp/estimate_fms_ym.jsp?est_id="+est_id+"&acar_id=<%=ck_acar_id%>&from_page=/fms2/lc_rent/lc_s_frame.jsp";
			}else{
		        <%if(esti_table.equals("estimate")){%>
		        SUBWIN="/acar/main_car_hp/estimate_fms.jsp?from_page=/acar/estimate_mng/esti_mng_u.jsp&est_id="+est_id+"&acar_id=<%=ck_acar_id%>";					
	    	    <%}else{%>
				SUBWIN="/acar/main_car_hp/estimate.jsp?est_id="+est_id+"&acar_id=<%=ck_acar_id%>";					
				<%}%>
			}	
		}		 
		window.open(SUBWIN, "EstiPrint", "left=50, top=50, width=698, height=600, scrollbars=yes, status=yes");
	}	
	
	//�����������
	function estimates_view(est_id, est_nm){
		var SUBWIN="/acar/estimate_mng/esti_mng_i_a_3_result_20090901_case.jsp?est_id="+est_id+"&car_gu=1&rent_st=1&est_code=<%=reg_code%>&est_nm="+est_nm+"&esti_table=<%=esti_table%>";
		window.open(SUBWIN, "ResultViewCase", "left=100, top=100, width=800, height=<%=s_height%>, scrollbars=yes, status=yes, resizable=yes");
	}	
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >
  <input type="hidden" name="reg_code" value='<%=reg_code%>'>          
<table border=0 cellspacing=0 cellpadding=0 width=<%=500+(100*vt_size)%>>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > <span class=style5>�������</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right"></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>  
	<tr> 
      <td>
        <table width=100% border="0" cellspacing="0" cellpadding="0">
          <tr> 
		    <td class="line">
			  <table width=400 border="0" cellspacing="1" cellpadding="0">
                <tr> 
				  <td class=title>������ȣ</td>
				</tr>
                <tr> 
				  <td class=title>����</td>
				</tr>
                <tr> 
				  <td class=title>�������</td>
				</tr>
                <tr> 
				  <td class=title>�̿�Ⱓ</td>
				</tr>
                <tr> 
				  <td class=title>�����ܰ���</td>
				</tr>
                <tr> 
				  <td class=title>������ ����24���� �ܰ���</td>
				</tr>
                <tr> 
				  <td class=title>2���� ����24���� �ܰ���</td>
				</tr>
                <tr> 
				  <td class=title>�����ܰ���</td>
				</tr>
                <tr> 
				  <td class=title>���� ���� ����ܰ���(�뿩���� ���� ����)</td>
				</tr>
                <tr> 
				  <td class=title>�뿩������� �⺻���� �ܰ���</td>
				</tr>
                <tr> 
				  <td class=title>�뿩���� ���� �߰�����1</td>
				</tr>
                <tr> 
				  <td class=title>�뿩���� ���� �߰�����2</td>
				</tr>
                <tr> 
				  <td class=title>�뿩���� ���� �߰�����</td>
				</tr>
                <tr> 
				  <td class=title>�������� ���� �ܰ���</td>
				</tr>
                <tr> 
				  <td class=title>���������-���⵵����</td>
				</tr>
                <tr> 
				  <td class=title>������Ͽ� �ݿ� �ܰ���</td>
				</tr>
                <tr> 
				  <td class=title>36���� �ʰ������� �ܰ� ������</td>
				</tr>
                <tr> 
				  <td class=title>���������� �ִ��ܰ���</td>
				</tr>
                <tr> 
				  <td class=title>���� ������Ÿ�</td>
				</tr>
                <tr> 
				  <td class=title>�߰����ܰ� ������ ���Ⱓ ��ǥ������Ÿ�</td>
				</tr>				
                <tr> 
				  <td class=title>ǥ������Ÿ� ��� ��������Ÿ� ����</td>
				</tr>
                <tr> 
				  <td class=title>�߰����� ������</td>
				</tr>				
                <tr> 
				  <td class=title>��������Ÿ� �ݿ� �ִ��ܰ���</td>
				</tr>	
                <tr> 
				  <td class=title>(��)������ �⺻���� �ܰ���</td>
				</tr>					
                <tr> 
				  <td class=title>(��)����Ÿ��� ���� �߰����� ������</td>
				</tr>					
                <tr> 
				  <td class=title>(��)����Ÿ��� ���� �߰����� ������</td>
				</tr>	
                <tr> 
				  <td class=title>(��)������ �߰�����(����Ÿ��ݿ�,������)</td>
				</tr>									
                <tr> 
				  <td class=title>(��)������ ����� ��������(����Ÿ��ݿ�)</td>
				</tr>	
                <tr> 
				  <td class=title>(��)�縮��������� �����ܰ���(����������忹��)</td>
				</tr>	
                <tr> 
				  <td class=title>(��)�縮��������� �����ܰ���(�����������)</td>
				</tr>									
                <tr> 
				  <td class=title>(��)�縮�� �� ������ ���� �����ܰ���</td>
				</tr>	
                <tr> 
				  <td class=title>(��)�߰��� ���庯ȯ�� ���� ����ũ�� ������ �����ܰ���</td>
				</tr>					
                <tr> 
				  <td class=title>(��)�߰��� �������� �����ܰ���(����)</td>
				</tr>															
                <tr> 
				  <td class=title>1�� ��������</td>
				</tr>															
                <tr> 
				  <td class=title>2�� ��������</td>
				</tr>															
                <tr> 
				  <td class=title>���� �� ��� �ܰ��ݿ�</td>
				</tr>															
                <tr> 
				  <td class=title>TUIX/TUON Ʈ��/�ɼ� ����</td>
				</tr>									
                <tr> 
				  <td class=title>÷�ܾ������/���ΰ�(������)</td>
				</tr>	
				<tr> 
				  <td class=title>���Ҽ����� �λ�ݾ�</td>
				</tr>								
                <tr> 
				  <td class=title>�뿩��(���ް�)</td>
				</tr>	
                <tr> 
				  <td class=title>��������</td>
				</tr>	
                <tr> 
				  <td class=title>������DC�ݾ�</td>
				</tr>	
                <tr> 
				  <td class=title>�������԰�</td>
				</tr>				
                <tr> 
				  <td class=title>�������԰�(���ް�)</td>
				</tr>				
                <tr> 
				  <td class=title>����ǥ�ؾ�</td>
				</tr>				
                <tr> 
				  <td class=title>��ϼ�</td>
				</tr>				
                <tr> 
				  <td class=title>��漼</td>
				</tr>				
                <tr> 
				  <td class=title>����ä�Ǹ��Ծ�</td>
				</tr>				
                <tr> 
				  <td class=title>ä������</td>
				</tr>				
                <tr> 
				  <td class=title>�����</td>
				</tr>				
                <tr> 
				  <td class=title>�������������</td>
				</tr>				
                <tr> 
				  <td class=title>������ü�����</td>
				</tr>				
                <tr> 
				  <td class=title>�����������</td>
				</tr>				
                <tr> 
				  <td class=title>�δ���</td>
				</tr>				
                <tr> 
				  <td class=title>Cash Back</td>
				</tr>				
                <tr> 
				  <td class=title>Ư�Ҽ�ȯ�Ծ����� ���簡ġ</td>
				</tr>				
                <tr> 
				  <td class=title>������</td>
				</tr>				
                <tr> 
				  <td class=title>����������</td>
				</tr>				
                <tr> 
				  <td class=title>�ڵ�����</td>
				</tr>				
                <tr> 
				  <td class=title>ȯ�氳���δ��</td>
				</tr>				
                <tr> 
				  <td class=title>���Ѻ�����</td>
				</tr>				
                <tr> 
				  <td class=title>��������</td>
				</tr>				
                <tr> 
				  <td class=title>�⺻���Ϲݰ�����</td>
				</tr>				
                <tr> 
				  <td class=title>�Ϲݽ��߰�������</td>
				</tr>				
                <tr> 
				  <td class=title>�⺻�Ŀ�������</td>
				</tr>				
                <tr> 
				  <td class=title>�ϹݽĿ�������</td>
				</tr>				
                <tr> 
				  <td class=title>�⺻�� �ݿ��� ����</td>
				</tr>				
                <tr> 
				  <td class=title>�⺻�Ĵ뿩��(���ް�)</td>
				</tr>				
                <tr> 
				  <td class=title>�Ϲݽ� �ݿ��� ����</td>
				</tr>				
                <tr> 
				  <td class=title>�Ϲݽ� �뿩��(���ް�)</td>
				</tr>				
                <tr> 
				  <td class=title>�ܰ�����������</td>
				</tr>				
                <tr> 
				  <td class=title>������ȿ��</td>
				</tr>				
                <tr> 
				  <td class=title>������ȿ��</td>
				</tr>				
                <tr> 
				  <td class=title>���ô뿩��ȿ��</td>
				</tr>				
                <tr> 
				  <td class=title>��������</td>
				</tr>				
                <tr> 
				  <td class=title>��������Ÿ�</td>
				</tr>				
                <tr> 
				  <td class=title>��������Ÿ�</td>
				</tr>				
                <tr> 
				  <td class=title>�ʰ�����δ��</td>
				</tr>	
				<tr> 
				  <td class=title>ȯ�޴뿩��</td>
				</tr>						
                <tr> 
				  <td class=title>����������</td>
				</tr>				
                <tr> 
				  <td class=title>�ʿ�������</td>
				</tr>				
                <tr> 
				  <td class=title>�̿�Ⱓ����ð�ġ</td>
				</tr>				
                <tr> 
				  <td class=title>�ܿ��Ⱓ�Ѵ뿩��</td>
				</tr>				
                <tr> 
				  <td class=title>AX81</td>
				</tr>				
                <tr> 
				  <td class=title>�Һα��Դ��</td>
				</tr>											
			  </table>	
			</td>		  
		    <td class="line">
			  <table width=400 border="0" cellspacing="1" cellpadding="0">
                <tr> 
				  <td class=title>EST_ID</td>
				</tr>
                <tr> 
				  <td class=title>GUBUN</td>
				</tr>
                <tr> 
				  <td class=title>RENT_DT</td>
				</tr>
                <tr> 
				  <td class=title>A_B</td>
				</tr>
                <tr> 
				  <td class=title>RO_13</td>
				</tr>
                <tr> 
				  <td class=title>O_B</td>
				</tr>
                <tr> 
				  <td class=title>O_C</td>
				</tr>
                <tr> 
				  <td class=title>O_D</td>
				</tr>
                <tr> 
				  <td class=title>O_E</td>
				</tr>
                <tr> 
				  <td class=title>O_F</td>
				</tr>
                <tr> 
				  <td class=title>O_G1</td>
				</tr>
                <tr> 
				  <td class=title>O_G2</td>
				</tr>
                <tr> 
				  <td class=title>O_G</td>
				</tr>
                <tr> 
				  <td class=title>O_H</td>
				</tr>
                <tr> 
				  <td class=title>DAY</td>
				</tr>
                <tr> 
				  <td class=title>O_I</td>
				</tr>
                <tr> 
				  <td class=title>O_K</td>
				</tr>
                <tr> 
				  <td class=title>O_M</td>
				</tr>
                <tr> 
				  <td class=title>BM7</td>
				</tr>
                <tr> 
				  <td class=title>BM9</td>
				</tr>				
                <tr> 
				  <td class=title>BM10</td>
				</tr>
                <tr> 
				  <td class=title>BM12</td>
				</tr>				
                <tr> 
				  <td class=title>BM14</td>
				</tr>				
                <tr> 
				  <td class=title>O_F_R</td>
				</tr>					
                <tr> 
				  <td class=title>O_R</td>
				</tr>					
                <tr> 
				  <td class=title>O_R_R</td>
				</tr>	
                <tr> 
				  <td class=title>O_S_R</td>
				</tr>									
                <tr> 
				  <td class=title>O_S</td>
				</tr>	
                <tr> 
				  <td class=title>O_U</td>
				</tr>	
                <tr> 
				  <td class=title>O_V</td>
				</tr>									
                <tr> 
				  <td class=title>O_W</td>
				</tr>	
                <tr> 
				  <td class=title>O_X</td>
				</tr>					
                <tr> 
				  <td class=title>O_Y</td>
				</tr>																	
                <tr> 
				  <td class=title>accid_serv_amt1</td>
				</tr>																	
                <tr> 
				  <td class=title>accid_serv_amt2</td>
				</tr>																	
                <tr> 
				  <td class=title>jg_opt_st</td>
				</tr>																	
                <tr> 
				  <td class=title>jg_tuix_st</td>
				</tr>																	
                <tr> 
				  <td class=title>lkas_yn/ldws_yn/aeb_yn/fcw_yn/hook_yn/(bk_172+bk_182)</td>
				</tr>	
				<tr> 
				  <td class=title>BK_190</td>
				</tr>																	
                <tr> 
				  <td class=title>FEE_S_AMT</td>
				</tr>	
                <tr> 
				  <td class=title>O_1</td>
				</tr>	
                <tr> 
				  <td class=title>DC_AMT</td>
				</tr>	
                <tr> 
				  <td class=title>S_A</td>
				</tr>				
                <tr> 
				  <td class=title>S_C</td>
				</tr>				
                <tr> 
				  <td class=title>S_D</td>
				</tr>				
                <tr> 
				  <td class=title>S_E</td>
				</tr>				
                <tr> 
				  <td class=title>S_G</td>
				</tr>				
                <tr> 
				  <td class=title>S_H</td>
				</tr>				
                <tr> 
				  <td class=title>S_J</td>
				</tr>				
                <tr> 
				  <td class=title>S_K</td>
				</tr>				
                <tr> 
				  <td class=title>S_M</td>
				</tr>				
                <tr> 
				  <td class=title>S_Q</td>
				</tr>				
                <tr> 
				  <td class=title>S_R</td>
				</tr>				
                <tr> 
				  <td class=title>S_S</td>
				</tr>				
                <tr> 
				  <td class=title>K_CB_3</td>
				</tr>				
                <tr> 
				  <td class=title>S_V</td>
				</tr>				
                <tr> 
				  <td class=title>S_W</td>
				</tr>				
                <tr> 
				  <td class=title>K_N</td>
				</tr>				
                <tr> 
				  <td class=title>K_R</td>
				</tr>				
                <tr> 
				  <td class=title>K_TT</td>
				</tr>				
                <tr> 
				  <td class=title>K_CH</td>
				</tr>				
                <tr> 
				  <td class=title>C_S</td>
				</tr>				
                <tr> 
				  <td class=title>G_6</td>
				</tr>				
                <tr> 
				  <td class=title>G_7</td>
				</tr>				
                <tr> 
				  <td class=title>K_T</td>
				</tr>				
                <tr> 
				  <td class=title>K_P</td>
				</tr>				
                <tr> 
				  <td class=title>K_H</td>
				</tr>				
                <tr> 
				  <td class=title>K_MM</td>
				</tr>				
                <tr> 
				  <td class=title>K_BB</td>
				</tr>				
                <tr> 
				  <td class=title>K_CC</td>
				</tr>				
                <tr> 
				  <td class=title>K_JD</td>
				</tr>				
                <tr> 
				  <td class=title>K_MO</td>
				</tr>				
                <tr> 
				  <td class=title>K_SO</td>
				</tr>				
                <tr> 
				  <td class=title>K_WO</td>
				</tr>				
                <tr> 
				  <td class=title>RG_8</td>
				</tr>				
                <tr> 
				  <td class=title>TODAY_DIST</td>
				</tr>				
                <tr> 
				  <td class=title>AGREE_DIST</td>
				</tr>				
                <tr> 
				  <td class=title>OVER_RUN_AMT</td>
				</tr>	
				<tr> 
				  <td class=title>RTN_RUN_AMT</td>
				</tr>				
                <tr> 
				  <td class=title>CLS_PER</td>
				</tr>				
                <tr> 
				  <td class=title>CLS_N_PER</td>
				</tr>				
                <tr> 
				  <td class=title>BK60</td>
				</tr>				
                <tr> 
				  <td class=title>BK61</td>
				</tr>				
                <tr> 
				  <td class=title>AX81</td>
				</tr>				
                <tr> 
				  <td class=title>AE93</td>
				</tr>											
			  </table>	
			</td>				
			<% 	if(vt.size()>0){
					for(int i=0; i<vt.size(); i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);%>		  
		    <td class="line">
			  <table width=150 border="0" cellspacing="1" cellpadding="0">
                <tr> 
				  <td align="center" style="font-size : 8pt;"><a href="javascript:go_esti_print('<%= ht.get("T_ST") %>', '<%= ht.get("EST_ID") %>', '<%= ht.get("MGR_SSN") %>');" onMouseOver="window.status=''; return true"><%=ht.get("EST_ID")%></a></td>				  
				</tr>
                <tr> 
				  <td  class=title style="font-size : 8pt;"><a href="javascript:estimates_view('<%= ht.get("EST_ID") %>', '<%=ht.get("GUBUN")%>')" title='������ ����'><%=ht.get("GUBUN")%></a></td>
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("RENT_DT")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("A_B")%></td>				  
				</tr>
                <tr> 
				  <td class=title style="font-size : 8pt;"><%=ht.get("RO_13")%>%</td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_B")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_C")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_D")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_E")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_F")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_G1")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_G2")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_G")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_H")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("DAY")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_I")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_K")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_M")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BM7")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BM9")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BM10")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BM12")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BM14")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_F_R")%></td>				  
				</tr>					
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_R")%></td>
				</tr>					
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_R_R")%></td>
				</tr>	
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_S_R")%></td>
				</tr>									
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_S")%></td>
				</tr>	
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_U")%></td>
				</tr>	
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_V")%></td>
				</tr>									
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_W")%></td>
				</tr>	
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_X")%></td>
				</tr>					
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_Y")%></td>
				</tr>												
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("ACCID_SERV_AMT1")%></td>
				</tr>									
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("ACCID_SERV_AMT2")%></td>
				</tr>									
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("JG_OPT_ST")%> <%=ht.get("JG_COL_ST")%></td>
				</tr>									
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("JG_TUIX_ST")%> <%=ht.get("JG_TUIX_OPT_ST")%></td>
				</tr>									
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("LKAS_YN")%> / <%=ht.get("LDWS_YN")%> / <%=ht.get("AEB_YN")%> / <%=ht.get("FCW_YN")%> / <%=ht.get("HOOK_YN")%> (<%=ht.get("BK_172")%>+<%=ht.get("BK_182")%>)</td>				  
				</tr>	
				<tr> 
				  <td class=title style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("BK_190")))%>��</td>				  
				</tr>								
                <tr> 
				  <td class=title style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%>��</td>				  
				</tr>
                <tr> 
				  <td class=title style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("O_1")))%>��</td>				  
				</tr>
                <tr> 
				  <td class=title style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("DC_AMT")))%>��</td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_A")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_C")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_D")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_E")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_G")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_H")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_J")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_K")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_M")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_Q")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_R")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_S")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_CB_3")%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("S_V")%></td>				  
				</tr>
                <tr> 
				  <td class="is" align="center" style="font-size : 8pt;" ><%=AddUtil.parseDecimal(String.valueOf(ht.get("S_W")))%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_N")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_R")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_TT")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_CH")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("C_S")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("G_6")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("G_7")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_T")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_P")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_H")%></td>				  
				</tr>				
                <tr> 
				  <td class="is" align="center" style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("K_MM")))%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_BB")%></td>				  
				</tr>				
                <tr> 
				  <td class="is" align="center" style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("K_CC")))%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_JD")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_MO")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_SO")%></td>				  
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("K_WO")%></td>				  
				</tr>	
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("RG_8")%>%</td>				  
				</tr>	
                <tr> 
				  <td class=title style="font-size : 8pt;"><%=ht.get("TODAY_DIST")%></td>
				</tr>				
                <tr> 
				  <td class=title style="font-size : 8pt;"><%=ht.get("AGREE_DIST")%></td>
				</tr>				
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("OVER_RUN_AMT")%></td>
				</tr>	
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("RTN_RUN_AMT")%></td>
				</tr>			
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("CLS_PER")%>%</td>
				</tr>											
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("CLS_N_PER")%>%</td>
				</tr>											
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BK60")%></td>
				</tr>											
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BK61")%></td>
				</tr>											
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("AX81")%></td>
				</tr>											
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("AE93")%></td>
				</tr>											
			  </table>	
			</td>
			<%		}
				}%>
		  </tr>
		</table>
	  </td>
	</tr>  	  	
</form>

</body>
</html>
