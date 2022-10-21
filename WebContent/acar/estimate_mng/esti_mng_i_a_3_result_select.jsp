<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.common.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	EstiDatabase e_db = EstiDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	

	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");

	String vid[] = request.getParameterValues("ch_l_cd");
	int vid_size = vid.length;
	
	Hashtable ht2 = new Hashtable();
	Vector vt = new Vector();
	
	for(int i=0; i < vid_size; i++){
		
		String est_id = vid[i];		
		String est_st = vid[i].substring(0,1);
		est_id = est_id.substring(1);
		
		if(est_st.equals("1")){
			ht2 = e_db.getEstiMateSelectResult(est_id);
		}else if(est_st.equals("2")){
			ht2 = e_db.getEstiMateSelectResultSh(est_id);
		}else if(est_st.equals("3")){
			ht2 = e_db.getEstiMateSelectResultCu(est_id);
		}
		
		vt.add(ht2);
		
	}
	
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

//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >
<table border=0 cellspacing=0 cellpadding=0 width=<%=550+(150*vt_size)%>>
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
				  <td class=title>����(1:����s, 2:�縮��, 3:��)</td>
				</tr>
                <tr> 
				  <td class=title>������ȣ</td>
				</tr>
				<tr> 
				  <td class=title>����ڵ�</td>
				</tr>
				<tr> 
				  <td class=title>����Ͻ�</td>
				</tr>
				<tr> 
				  <td class=title>�����</td>
				</tr>
                <tr> 
				  <td class=title>�����ڵ�</td>
				</tr>
                <tr> 
				  <td class=title>�������</td>
				</tr>
				<tr> 
				  <td class=title>��ǰ</td>
				</tr>
                <tr> 
				  <td class=title>�̿�Ⱓ</td>
				</tr>
				<tr> 
				  <td class=title>est_from</td>
				</tr>
				<tr> 
				  <td class=title>��������Ÿ�</td>
				</tr>
				<tr> 
				  <td class=title>�ִ밳����</td>
				</tr>
				<tr> 
				  <td class=title>ǥ���ִ��ܰ�</td>
				</tr>
				<tr> 
				  <td class=title>�ִ��ܰ�����ġ</td>
				</tr>
				<tr> 
				  <td class=title>�����ִ��ܰ�</td>
				</tr>
                <tr> 
				  <td class=title>�����ܰ���</td>
				</tr>
				<tr> 
				  <td class=title>�����ܰ�</td>
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
				  <td class=title>ADD_O_13</td>
				</tr>
				<tr> 
				  <td class=title>ACCID_SIK_J</td>
				</tr>
				<tr> 
				  <td class=title>JG_B_DT</td>
				</tr>
				<tr> 
				  <td class=title>EM_A_J</td>
				</tr>
				<tr> 
				  <td class=title>EA_A_J</td>
				</tr>
				<tr> 
				  <td class=title>P_O_1</td>
				</tr>
				<tr> 
				  <td class=title>JG_C_1</td>
				</tr>
				<tr> 
				  <td class=title>O_Q1</td>
				</tr>
				<tr> 
				  <td class=title>O_Q2</td>
				</tr>
				<tr> 
				  <td class=title>O_Q3</td>
				</tr>
				<tr> 
				  <td class=title>O_Q4</td>
				</tr>
				<tr> 
				  <td class=title>G_9</td>
				</tr>
				<tr> 
				  <td class=title>G_10</td>
				</tr>
				<tr> 
				  <td class=title>A_M_4</td>
				</tr>
				<tr> 
				  <td class=title>O_T</td>
				</tr>
				<tr> 
				  <td class=title>T_BD</td>
				</tr>
				<tr> 
				  <td class=title>GB917</td>
				</tr>
				<tr> 
				  <td class=title>FW917</td>
				</tr>
				<tr> 
				  <td class=title>V_VAR1</td>
				</tr>
				<tr> 
				  <td class=title>V_VAR2</td>
				</tr>
				<tr> 
				  <td class=title>V_VAR3</td>
				</tr>
				<tr> 
				  <td class=title>N_VAR1</td>
				</tr>
				<tr> 
				  <td class=title>N_VAR2</td>
				</tr>
				<tr> 
				  <td class=title>N_VAR3</td>
				</tr>
				<tr> 
				  <td class=title>BC_B_E1</td>
				</tr>
				<tr> 
				  <td class=title>BC_B_E2</td>
				</tr>
				<tr> 
				  <td class=title>ETC</td>
				</tr>
				<tr> 
				  <td class=title>A_M_3</td>
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
				  <td class=title>÷�ܾ������</td>
				</tr>	
				<tr> 
				  <td class=title>÷�ܾ������</td>
				</tr>
				<tr> 
				  <td class=title>÷�ܾ������</td>
				</tr>
				<tr> 
				  <td class=title>÷�ܾ������</td>
				</tr>
				<tr> 
				  <td class=title>÷�ܾ������</td>
				</tr>
				<tr> 
				  <td class=title>÷�ܾ������/���ΰ�(������)</td>
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
				  <td class=title>������</td>
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
			  <table width=150 border="0" cellspacing="1" cellpadding="0">
                <tr> 
				  <td class=title>ST</td>
				</tr>
				<tr> 
				  <td class=title>EST_ID</td>
				</tr>
				<tr> 
				  <td class=title>REG_CODE</td>
				</tr>
				<tr> 
				  <td class=title>REG_DT</td>
				</tr>
				<tr> 
				  <td class=title>REG_ID</td>
				</tr>
                <tr> 
				  <td class=title>JG_CODE</td>
				</tr>
                <tr> 
				  <td class=title>RENT_DT</td>
				</tr>
				<tr> 
				  <td class=title>A_A</td>
				</tr>
                <tr> 
				  <td class=title>A_B</td>
				</tr>
				<tr> 
				  <td class=title>est_from</td>
				</tr>
				<tr> 
				  <td class=title>agree_dist</td>
				</tr>
				<tr> 
				  <td class=title>max_use_mon</td>
				</tr>
                <tr> 
				  <td class=title>B_O_13</td>
				</tr>
				<tr> 
				  <td class=title>ADD_O_13</td>
				</tr>
				<tr> 
				  <td class=title>O_13</td>
				</tr>
				<tr> 
				  <td class=title>RO_13</td>
				</tr>
				<tr> 
				  <td class=title>RO_13_AMT</td>
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
				  <td class=title>ADD_O_13</td>
				</tr>
				<tr> 
				  <td class=title>ACCID_SIK_J</td>
				</tr>
				<tr> 
				  <td class=title>JG_B_DT</td>
				</tr>
				<tr> 
				  <td class=title>EM_A_J</td>
				</tr>
				<tr> 
				  <td class=title>EA_A_J</td>
				</tr>
				<tr> 
				  <td class=title>P_O_1</td>
				</tr>
				<tr> 
				  <td class=title>JG_C_1</td>
				</tr>
				<tr> 
				  <td class=title>O_Q1</td>
				</tr>
				<tr> 
				  <td class=title>O_Q2</td>
				</tr>
				<tr> 
				  <td class=title>O_Q3</td>
				</tr>
				<tr> 
				  <td class=title>O_Q4</td>
				</tr>
				<tr> 
				  <td class=title>G_9</td>
				</tr>
				<tr> 
				  <td class=title>G_10</td>
				</tr>
				<tr> 
				  <td class=title>A_M_4</td>
				</tr>
				<tr> 
				  <td class=title>O_T</td>
				</tr>
				<tr> 
				  <td class=title>T_BD</td>
				</tr>
				<tr> 
				  <td class=title>GB917</td>
				</tr>
				<tr> 
				  <td class=title>FW917</td>
				</tr>
				<tr> 
				  <td class=title>V_VAR1</td>
				</tr>
				<tr> 
				  <td class=title>V_VAR2</td>
				</tr>
				<tr> 
				  <td class=title>V_VAR3</td>
				</tr>
				<tr> 
				  <td class=title>N_VAR1</td>
				</tr>
				<tr> 
				  <td class=title>N_VAR2</td>
				</tr>
				<tr> 
				  <td class=title>N_VAR3</td>
				</tr>
				<tr> 
				  <td class=title>BC_B_E1</td>
				</tr>
				<tr> 
				  <td class=title>BC_B_E2</td>
				</tr>
				<tr> 
				  <td class=title>ETC</td>
				</tr>
				<tr> 
				  <td class=title>A_M_3</td>
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
				  <td class=title>lkas_yn</td>
				</tr>	
				<tr> 
				  <td class=title>ldws_yn</td>
				</tr>
				<tr> 
				  <td class=title>aeb_yn</td>
				</tr>
				<tr> 
				  <td class=title>fcw_yn</td>
				</tr>
				<tr> 
				  <td class=title>hook_yn</td>
				</tr>
				<tr> 
				  <td class=title>bk_172</td>
				</tr>
				<tr> 
				  <td class=title>bk_182</td>
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
				  <td class=title>GTR_AMT</td>
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
				  <td align="center" style="font-size : 8pt;"><%=ht.get("ST")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("EST_ID")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("REG_CODE")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("REG_DT")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("REG_ID")%></td>				  
				</tr>
                <tr> 
				  <td  class=title style="font-size : 8pt;"><%=ht.get("JG_CODE")%></td>
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("RENT_DT")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=c_db.getNameByIdCode("0009", "", String.valueOf(ht.get("A_A")))%></td>				  
				</tr>
                <tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("A_B")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("EST_FROM")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("AGREE_DIST")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("MAX_USE_MON")%></td>				  
				</tr>
                <tr> 
				  <td class=title style="font-size : 8pt;"><%=ht.get("B_O_13")%>%</td>				  
				</tr>
				<tr> 
				  <td class=title style="font-size : 8pt;"><%=ht.get("ADD_O_13")%></td>				  
				</tr>
				<tr> 
				  <td class=title style="font-size : 8pt;"><%=ht.get("O_13")%>%</td>				  
				</tr>
				<tr> 
				  <td class=title style="font-size : 8pt;"><%=ht.get("RO_13")%>%</td>				  
				</tr>
				<tr> 
				  <td class=title style="font-size : 8pt;"><%=ht.get("RO_13_AMT")%></td>				  
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
				  <td align="center" style="font-size : 8pt;"><%=ht.get("ADD_O_13")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("ACCID_SIK_J")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("JG_B_DT")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("EM_A_J")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("EA_A_J")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("P_O_1")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("JG_C_1")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_Q1")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_Q2")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_Q3")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_Q4")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("G_9")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("G_10")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("A_M_4")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("O_T")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("T_BD")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("GB917")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("FW917")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("V_VAR1")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("V_VAR2")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("V_VAR3")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("N_VAR1")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("N_VAR2")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("N_VAR3")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BC_B_E1")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BC_B_E2")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("ETC")%></td>
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("A_M_3")%></td>
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
				  <td align="center" style="font-size : 8pt;"><%=ht.get("LKAS_YN")%></td>				  
				</tr>	
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("LDWS_YN")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("AEB_YN")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("FCW_YN")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("HOOK_YN")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BK_172")%></td>				  
				</tr>
				<tr> 
				  <td align="center" style="font-size : 8pt;"><%=ht.get("BK_182")%></td>				  
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
				  <td align="center" style="font-size : 8pt;"><%=ht.get("GTR_AMT")%></td>				  
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
