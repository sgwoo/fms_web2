<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.condition.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String exp_dt = request.getParameter("exp_dt")==null?"":request.getParameter("exp_dt");
	String lend_int = request.getParameter("lend_int")==null?"0.0":request.getParameter("lend_int"); //��������
	String lend_cond = request.getParameter("lend_cond")==null?"1":request.getParameter("lend_cond"); //��ȯ����
	
	int count = 0;
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "06");
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	//��ĵ���� ����
	function view_scan(m_id, l_cd){
		window.open("/acar/car_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=100, width=620, height=500, scrollbars=yes");		
	}			

	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
	
	//����ϱ�
	function bank_doc_reg(){	
		var fm = document.form1;
		var sh_fm = parent.c_body.document.form1;		
		
		fm.doc_id.value 	= sh_fm.doc_id.value;
		fm.doc_dt.value 	= sh_fm.doc_dt.value;
		fm.fund_yn.value 	= sh_fm.fund_yn.value;
	
		fm.bank_id.value 	= sh_fm.bank_id.value;
		fm.bank_nm.value 	= sh_fm.bank_nm.value;		
		
		fm.mng_dept.value 	= sh_fm.mng_dept.value;
		fm.mng_nm.value 	= sh_fm.mng_nm.value;
		fm.mng_pos.value 	= sh_fm.mng_pos.value;
		fm.title.value 	= sh_fm.title.value;	
		fm.h_mng_id.value 	= sh_fm.h_mng_id.value;
		fm.b_mng_id.value 	= sh_fm.b_mng_id.value;
		fm.app_doc1.value 	= sh_fm.app_doc1.value;
		fm.app_doc2.value 	= sh_fm.app_doc2.value;
		fm.app_doc3.value 	= sh_fm.app_doc3.value;
		fm.app_doc4.value 	= sh_fm.app_doc4.value;
		fm.app_doc5.value 	= sh_fm.app_doc5.value;
		
		fm.cltr_rat.value 	= sh_fm.cltr_rat.value;
		fm.cltr_amt.value 	= sh_fm.cltr_amt.value;	
		
		fm.off_id.value 	= sh_fm.off_id.value;
		fm.seq.value 	= sh_fm.seq.value;
			
		if(fm.doc_id.value == '')		{ alert('������ȣ�� �Է��Ͻʽÿ�.'); return; }
		if(fm.doc_dt.value == '')		{ alert('�������ڸ� �Է��Ͻʽÿ�.'); return; }		
		if(fm.bank_id.value == '')		{ alert('���ű���� �����Ͻʽÿ�.'); return; }		
		if(fm.bank_nm.value == '')		{ alert('���ű���� �����Ͻʽÿ�.'); return; }

		if(fm.size.value == '0')		{ alert('����� ��ȸ �Ͻʽÿ�.'); return; }
		

		//�Ե����丮���� ���� �����缳���� �Է¹޾ƾ� ��  
		if(fm.bank_id.value == '0093')	{  
			if ( fm.cltr_rat.value  == '') { alert('�����缳���� �Է��Ͻʽÿ�.'); return; }
		}

		if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}
		fm.action = "bank_doc_reg_sc_a.jsp";
		fm.target = "i_no";
		fm.submit()
	}	
//-->
</script>

</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='doc_id' value=''>
<input type='hidden' name='doc_dt' value=''>
<input type='hidden' name='fund_yn' value=''>
<input type='hidden' name='bank_id' value=''>
<input type='hidden' name='bank_nm' value=''>
<input type='hidden' name='mng_dept' value=''>
<input type='hidden' name='mng_nm' value=''>
<input type='hidden' name='mng_pos' value=''>
<input type='hidden' name='title' value=''>
<input type='hidden' name='h_mng_id' value=''>
<input type='hidden' name='b_mng_id' value=''>
<input type='hidden' name='app_doc1' value=''>
<input type='hidden' name='app_doc2' value=''>
<input type='hidden' name='app_doc3' value=''>
<input type='hidden' name='app_doc4' value=''>
<input type='hidden' name='app_doc5' value=''>
<input type='hidden' name='cltr_rat' value=''>
<input type='hidden' name='cltr_amt' value=''>
<input type='hidden' name='exp_dt' value='<%=exp_dt%>'>
<input type='hidden' name='lend_int' value='<%=lend_int%>'>
<input type='hidden' name='lend_cond' value='<%=lend_cond%>'>
<input type='hidden' name='seq' value=''>
<input type='hidden' name='off_id' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                     <td class='title' width="6%">����</td>
                    <td width='13%' class='title'>��ȣ</td>
                    <td width='8%' class='title'>�Ⱓ(��)</td>
                    <td width='12%' class='title'>���뿩��</td>
                    <td width='12%' class='title'>�Ѵ뿩��</td>
                    <td width='14%' class='title'>����</td>
                    <td width='11%' class='title'>������ȣ</td>
                    <td width='12%' class='title'>���԰���</td>
                    <td width='12%' class='title'>����ݾ�</td>
                            
                </tr>
<% 	
	//���ø���Ʈ
	ConditionDatabase cdb = ConditionDatabase.getInstance();
	
	String vid[] = request.getParameterValues("cho_id");
	String vid_num="";
	String ch_m_id="";
	String ch_l_cd="";
	String ch_c_id="";
	String ch_bank_id="";

	float loan_amt = 0;
	int loan_amt1 = 0;
		
	float loan_a_amt = 0;
	float loan_b_amt = 0;
	
	int loan_a_amt1 = 0;
	int loan_b_amt1 = 0;
	
	float  tax_amt = 0;  //��漼 -- ��� ��漼 ����
	float  tax_a_amt = 0;  //��漼
	float  tax_b_amt = 0;  //��漼
	int    tax_amt1 = 0; //��漼
	int    tax_a_amt1 = 0; //��漼
	int    tax_b_amt1 = 0; //��漼
	
	int loan_amt1_tot = 0; //����ݾ� �հ�
	int  ecar_pur_amt = 0; //���ź����� 
	int  car_f_amt = 0;   //�츮ī��(0046)�϶��� ���  	
	int  car_dc_amt = 0;   //�츮ī��(0046)�϶��� ���  	
	
	for(int i=0; i<vid.length;i++){
		vid_num=vid[i];
		
		StringTokenizer token1 = new StringTokenizer(vid_num,"^");
				
		while(token1.hasMoreTokens()) {
				
				ch_m_id = token1.nextToken().trim();	 
				ch_l_cd = token1.nextToken().trim();	 
				ch_c_id = token1.nextToken().trim();	 
				ch_bank_id = token1.nextToken().trim();	 		
								
		}		
				
		Hashtable loan = cdb.getLoanListExcel(ch_m_id, ch_l_cd, ch_c_id);
		
		// ���� ����Ÿ ȭ 
		//�Ե�ĳ��Ż , ��ȯĳ��Ż, ȿ��ĳ��Ż, �츮���̳���, KT ĳ��Ż, IBKĳ��Ż, HK��������, ����ĳ��Ż, �츮������������, ��������, SBi 3 ��������(0068) ,�ѱ���Ƽ�׷�ĳ��Ż(0069), ������������(0072), SBi 4 ��������(0073) , �ϳ�����(0074), aj�κ���Ʈ(0076)
		// kbĳ��Ż(0078), ��������(0081), ��������(0083), �ﱹ����(0084) ,kb����(0085) , ��������(0088), �μ�����(0089), ������������(0090), �ѽ���������(0094), ��������(0100) , ����Ƽ����(0101) , bnkĳ��Ż(0102) , kb����ī��(0103), ��Ÿ����(0104)
		//��ȭ����(0111) , ibk����(0113), �Ե�ī�� (0114) , ��ȭ����(0115)
		//����ݾ� 
		if (	   ch_bank_id.equals("0038") || ch_bank_id.equals("0040") || ch_bank_id.equals("0039") || ch_bank_id.equals("0051") || ch_bank_id.equals("0057") || ch_bank_id.equals("0059")  
				|| ch_bank_id.equals("0058") || ch_bank_id.equals("0060") || ch_bank_id.equals("0028") || ch_bank_id.equals("0068") || ch_bank_id.equals("0069") || ch_bank_id.equals("0072")
				|| ch_bank_id.equals("0073") || ch_bank_id.equals("0074") || ch_bank_id.equals("0076") || ch_bank_id.equals("0077") || ch_bank_id.equals("0078") || ch_bank_id.equals("0081")  
				|| ch_bank_id.equals("0083") || ch_bank_id.equals("0084") || ch_bank_id.equals("0085") || ch_bank_id.equals("0088") || ch_bank_id.equals("0089") || ch_bank_id.equals("0090")
				|| ch_bank_id.equals("0092") || ch_bank_id.equals("0094") || ch_bank_id.equals("0100") || ch_bank_id.equals("0101") || ch_bank_id.equals("0102") || ch_bank_id.equals("0103")
				|| ch_bank_id.equals("0104") || ch_bank_id.equals("0110") || ch_bank_id.equals("0111") || ch_bank_id.equals("0113") || ch_bank_id.equals("0114") || ch_bank_id.equals("0115") ) { 
		         loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) *  90/100;
		} else if (ch_bank_id.equals("0009") || ch_bank_id.equals("0001") || ch_bank_id.equals("0003") || ch_bank_id.equals("0099") || ch_bank_id.equals("0086") || ch_bank_id.equals("0010") 
				|| ch_bank_id.equals("0079") || ch_bank_id.equals("0056") || ch_bank_id.equals("0091") || ch_bank_id.equals("0116") || ch_bank_id.equals("0093") ) { //����ĳ��Ż or �������� or �ϳ����� or �츮���� , �ѱ�ĳ��Ż(0099) , ������ĳ��Ż(0086-201808 ����) , �޸���,kdbĳ��Ż(20191119���� ) , ��ť��ĳ��Ż(20200212����) , dbĳ��Ż(202009����), �Ե����丮��(0093)
				 loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) *  90/100;
		} else if (ch_bank_id.equals("0055") || ch_bank_id.equals("0064") || ch_bank_id.equals("0065") || ch_bank_id.equals("0075") || ch_bank_id.equals("0080") || ch_bank_id.equals("0082") 
				|| ch_bank_id.equals("0087")   ) { //����ĳ��Ż , BSĳ��Ż, �޸���, ��ȭ������, ���ĳ��Ż , �޸���ĳ��Ż(0079) , ok����(0080), �������(0082) , orix , �����̾�����(0087),  �Ե����丮��(0093) , 
				 loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) /  AddUtil.parseFloat("1.1");
		} else if (ch_bank_id.equals("0043") || ch_bank_id.equals("0044") || ch_bank_id.equals("0041") || ch_bank_id.equals("0002") || ch_bank_id.equals("0063") || ch_bank_id.equals("0118") ) { //�λ�ĳ��Ż, nhĳ��Ż , �ϳ�ĳ��Ż , ��ȯ����, DGBĳ��Ż, �޸��� , �츮����ĳ��Ż
				 loan_a_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) - (AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT")))*10/100 ); 
				 loan_a_amt1 = (int) loan_a_amt;
			     loan_a_amt1 = AddUtil.ten_th_rnd(loan_a_amt1);		     
	    } else if (ch_bank_id.equals("0018") ) { //�Ｚī�� :20160318 80->90%, �������(0037) 20160712
	           	 loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) *  90/100;	
	    } else if (ch_bank_id.equals("0109") ) { //����ī��������(0109 
	             loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) *  80/100;
	    } else if (ch_bank_id.equals("0026")  ) { //�뱸���� ���ް��� ����
	             loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_S_AMT"))) * 100/100;                  
	    } else if (ch_bank_id.equals("0004") || ch_bank_id.equals("0025") ) { //��������  ,  �λ�����   	
	             loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_S_AMT"))) * 90/100;                          
	    } else if (ch_bank_id.equals("0037") || ch_bank_id.equals("0005") ) { //������� --20180508  - 20190507-80% �������� (20200602-80%)
					//		loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) /  AddUtil.parseFloat("1.1") *  87/100;	      
	         	 loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_S_AMT"))) *  80/100;
	    } else if (ch_bank_id.equals("0046") ) { //�츮ī��(0046) - ���������� 80% - 202104		 
     			// loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_F_AMT"))) *  80/100;  
     			car_f_amt = AddUtil.parseDigit(String.valueOf(loan.get("CAR_F_AMT")));  //��������   
		 		car_dc_amt = AddUtil.parseDigit(String.valueOf(loan.get("CAR_DC_AMT")));  //dc�ݾ�    
		 		loan_a_amt1 = car_f_amt - car_dc_amt;		 
		 		loan_a_amt = AddUtil.parseFloat(Integer.toString(loan_a_amt1)) *  80/100;  		 			 		
		 		loan_a_amt1 = (int) loan_a_amt;
		 		loan_a_amt1 = AddUtil.th_rnd(loan_a_amt1); 
	        		        	
	    } else if ( ch_bank_id.equals("0033") ) { //��������	, ��������  --���ް�100%
				 loan_a_amt =  AddUtil.parseFloat(String.valueOf(loan.get("CAR_S_AMT"))) * 100/100;
				 loan_a_amt1 = (int) loan_a_amt;
	             loan_a_amt1 = AddUtil.ten_th_rnd(loan_a_amt1); 		
		} else if (ch_bank_id.equals("0011") || ch_bank_id.equals("0108") ) { //����ĳ��Ż(0011) , ����Ŀ�Ӽ�(0108) - ���԰��� ����
				 loan_a_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) ;	     
				 loan_a_amt1 = (int) loan_a_amt;	      	
	       //      loan_a_amt1 = AddUtil.ten_th_rnd(loan_a_amt1); 		 //20170912 ���� 
	             loan_a_amt1 = AddUtil.hun_th_rnd(loan_a_amt1); 		 //20170912 ���� 
		} else if (ch_bank_id.equals("0029") ) { //��������(0029)  ���԰��� ���� - 2021�� 
			 loan_a_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) *  90/100;	 
			 loan_a_amt1 = (int) loan_a_amt;	      	
            loan_a_amt1 = AddUtil.ten_th_rnd(loan_a_amt1); 		          
	    //  	} else if ( ch_bank_id.equals("0056") ) { //kt���԰��� ����
		//			loan_amt = AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT"))) ;	     	           	  	
	    } else {
	             loan_amt =  0;
	   	}
			
		loan_amt1 = (int) loan_amt;
		
		if (	   ch_bank_id.equals("0043") || ch_bank_id.equals("0044") || ch_bank_id.equals("0041") || ch_bank_id.equals("0002") || ch_bank_id.equals("0011")  || ch_bank_id.equals("0108") 
	 			|| ch_bank_id.equals("0063") || ch_bank_id.equals("0029") || ch_bank_id.equals("0033") || ch_bank_id.equals("0046") || ch_bank_id.equals("0118") ) {
				loan_amt1 = loan_a_amt1;
		} else if (ch_bank_id.equals("0026")   ) { 
				loan_amt1 = loan_amt1;
		} else if (ch_bank_id.equals("0037")   ) { 	 //�Ｚī������ - 20191212
	//	} else if (ch_bank_id.equals("0018") || ch_bank_id.equals("0037")   ) { 		
				loan_amt1 = AddUtil.th_rnd(loan_amt1);
	//	} else if (ch_bank_id.equals("0037") ) { 
	//		loan_amt1 = AddUtil.hun_th_rnd(loan_amt1);
		} else {
				loan_amt1 = AddUtil.ten_th_rnd(loan_amt1);
	    } 
        
		//���ź������� �ִ� ��� ������ - 20210401
		ecar_pur_amt = AddUtil.parseDigit(String.valueOf(loan.get("ECAR_PUR_AMT")));  //���ź�����   
       	loan_amt1 = loan_amt1 - ecar_pur_amt;    
			
        int ep = 0;
        int ep3 = 0;
        int ep4 = 0;
                    
        int ep1 = 0;
        int ep2 = 0;
              	
        //����, �λ�, �ϳ�, �Ｚī��, ����,dgb, �޸���, orix  ��  �� ��漼 - �������� (20130911) , �޸�������(0079) - 20160217  - 20181210 �ϳ���Ż(0041) ���� , ����ĳ��Ż(20211018) - �����ڱ��� ���
        if ( ch_bank_id.equals("0043") || ch_bank_id.equals("0058") || ch_bank_id.equals("0063") || ch_bank_id.equals("0064") || ch_bank_id.equals("0011")  ) {   

			ep1 = String.valueOf(loan.get("CAR_NM")).indexOf("���");
			ep2 = String.valueOf(loan.get("CAR_NM")).indexOf("����ũ");
			
			ep   = String.valueOf(loan.get("CAR_NO")).indexOf("��");   // 2: �㰡 ������
			ep3 = String.valueOf(loan.get("CAR_NO")).indexOf("��");
			ep4 = String.valueOf(loan.get("CAR_NO")).indexOf("ȣ");
			
            //����ĳ��Ż_������ ��쿡 ���ؼ� ��漼 ( 2%*2 �� ��� (���ϼ��� ���� ��� - ���� 4% -20211021))
		    if ((String.valueOf(loan.get("CAR_NM")).equals("���") ||  String.valueOf(loan.get("CAR_NM")).equals("����ũ")) && (ep == 2 ||   ep3 == 2 ||ep4 == 2  ) ) {
	        	 tax_amt = (AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT")))/ AddUtil.parseFloat("1.1") )* 2/100;
		      	 tax_amt1 = (int) tax_amt;   
		       	 tax_amt1 = AddUtil.l_th_rnd(tax_amt1);
		     }  else if (ep1 == -1 &&  ep2 == -1) {		    	
	        	 tax_amt = (AddUtil.parseFloat(String.valueOf(loan.get("CAR_AMT")))/ AddUtil.parseFloat("1.1") )* 2/100;
		      	 tax_amt1 = (int) tax_amt;   
		       	 tax_amt1 = AddUtil.l_th_rnd(tax_amt1);		    		 
		     }  else{   	 
	             tax_amt1 = 0;
	         }  
				    
        }
		
		loan_amt1_tot += loan_amt1;
%>		  
 		        <tr align="center"> 
                    <td><%=i+1%></td>
                	<input type='hidden' name='car_mng_id' value='<%=ch_c_id%>'>
        			<input type='hidden' name='rent_mng_id' value='<%=ch_m_id%>'>
        			<input type='hidden' name='rent_l_cd' value='<%=ch_l_cd%>'>			
        			<input type='hidden' name='rent_s_cd' value=''>
        			<input type='hidden' name='firm_nm' value='<%=loan.get("FIRM_NM")%>'>
        			<input type='hidden' name='fee_amt' value='<%=loan.get("FEE_AMT")%>'>
        			<input type='hidden' name='tot_fee_amt' value='<%=loan.get("TOT_FEE_AMT")%>'>
        			<input type='hidden' name='car_amt' value='<%=loan.get("CAR_AMT")%>'>
        			<input type='hidden' name='loan_amt' value='<%=loan_amt1%>'>
       				<input type='hidden' name='tax_amt' value='<%=tax_amt1%>'>
        			<input type='hidden' name='con_mon' value='<%=loan.get("CON_MON")%>'>	
        			<input type='hidden' name='car_f_amt' value='<%=loan.get("CAR_F_AMT")%>'> <!--  0046�϶��� ���  -->		
        			<input type='hidden' name='car_dc_amt' value='<%=loan.get("CAR_DC_AMT")%>'> <!--  0046�϶��� ���  -->		
                    <td><span title='<%=loan.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(loan.get("FIRM_NM")), 7)%></td>
                    <td><%=loan.get("CON_MON")%></td>
                    <td align=right><%=Util.parseDecimal(loan.get("FEE_AMT"))%></td>
                    <td align=right><%=Util.parseDecimal(loan.get("TOT_FEE_AMT"))%></td>
                    <td><%=Util.subData(String.valueOf(loan.get("CAR_NM")), 8)%></td>
                    <td><%=loan.get("CAR_NO")%></td>
                    <td align=right><%=Util.parseDecimal(loan.get("CAR_AMT"))%></td>
                    <td align=right><%=Util.parseDecimal(loan_amt1)%></td>
                </tr>

<%		count++;
	}%>		
		    <input type='hidden' name='size' value='<%=count%>'>  
				<tr>
					<td colspan="8" class='title'>�հ�</td>
					<td align=right><%=Util.parseDecimal(loan_amt1_tot)%>�� </td>
				</tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">
	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	    <a href='javascript:bank_doc_reg()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
	    <%}%>
	    </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
