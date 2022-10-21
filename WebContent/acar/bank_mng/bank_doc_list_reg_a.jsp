<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
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

	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
			
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	
	String cmd			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");	
	
	int    scd_size 	= request.getParameter("scd_size")		==null?0 :AddUtil.parseInt(request.getParameter("scd_size"));
	
	int  cltr_rat = request.getParameter("cltr_rat")==null?0:Util.parseInt(request.getParameter("cltr_rat"));  //�Ե����丮�������� ��� (202204)
	
	int count = 0;
	int cnt = 0;
	boolean flag = true;
	
	String value0[]  = request.getParameterValues("seq_no");
	String value1[]  = request.getParameterValues("amt4"); //�������
	String value2[]  = request.getParameterValues("amt5"); //��漼
	String value3[]  = request.getParameterValues("ss_amt"); //�㺸�����ݾ�
	String value4[]  = request.getParameterValues("amt3"); //���Ű���
	
	int  seq_no = 0;  //����
	int  amt3 = 0;  // ���Ű���
	int  amt4 = 0;  //�������
	int  amt5 = 0;  //��漼
	int  amt6 = 0;  //�㺸������
	int dam_amt = 0;
	float  dam_f_amt = 0;  //�㺸������	
		
	for(int i=0 ; i < scd_size ; i++){
								
		seq_no = value0[i]	==null?0 :AddUtil.parseDigit(value0[i]);
			
		amt4 = value1[i]	==null?0 :AddUtil.parseDigit(value1[i]);
		amt5 = value2[i]	==null?0 :AddUtil.parseDigit(value2[i]);
			
	//	System.out.println("����ݾ� �Ǻ� ����="+  amt4 +":"+ amt5);	
	
		amt6 = value3[i]	==null?0 :AddUtil.parseDigit(value3[i]);  //�㺸����
		amt3 = value4[i]	==null?0 :AddUtil.parseDigit(value4[i]);
				
                    
                     // �Ｚī��� 20% �㺸 
			if ( 		bank_id.equals("0018") ) {			
			        dam_amt =  FineDocDb.getDamAmt(amt4, 0);		
			} else if ( bank_id.equals("0002")    ) {			
			        dam_amt =  FineDocDb.getDamAmt1(amt3);			  
			} else if  ( bank_id.equals("0044")  )  {
			        dam_amt = 		amt4+ amt5 ;
			} else if  ( bank_id.equals("0058")  )  {
				    dam_amt =	1000000;   //�㺸������
			} else if  ( bank_id.equals("0025")  ||  bank_id.equals("0004") )  {  //��������, �λ�����, �������, �Ե����丮�� , ��������(11/06)
				    dam_amt =0;   //�㺸������	
			} else if  ( bank_id.equals("0041")  ||  bank_id.equals("0055") ||  bank_id.equals("0069") ||  bank_id.equals("0102")   )  {  //�ϳ�ĳ��Ż �㺸 50%->20% ����, ����ĳ��Ż 0%->20%, ��������(0072) , bnkĳ��Ż(0102)
			             dam_amt =	 (amt4 + amt5) /5 ;
			} else if  ( bank_id.equals("0011")  ||  bank_id.equals("0108") )  {  //����ĳ��Ż �㺸 20%->50% ���� , ����Ŀ�Ӽ�(0108)
	             dam_amt =	 (amt4 + amt5) /2 ;	
		    } else if (  bank_id.equals("0076")  ||  bank_id.equals("0081") ||  bank_id.equals("0074") ||  bank_id.equals("0084")   ) {		//, ��������(0081) - ���԰��� 50%
		        		dam_amt =  FineDocDb.getDamAmt2(amt3);	
		    } else if (  bank_id.equals("0101") || bank_id.equals("0114")  ) {		//, ����Ƽ����(0101) - ���� ���� 50% , �Ե�ī��(0114) -202104����
		        		dam_amt =  FineDocDb.getDamAmt2(amt4);	    
		    } else if (  bank_id.equals("0059")  ) {		// hk����(0059) - ���� ���� 30%
		        		dam_amt =  FineDocDb.getDamAmt3(amt4);	  
		    } else if (  bank_id.equals("0072")  ) {		// ��������(0072) - ���� ���� 10% 
        				dam_amt =  FineDocDb.getDamAmtRate(10, amt4);  
		    } else if (  bank_id.equals("0093")  ) {		// �Ե����丮��(0093) - ���� ���� 70% - �㺸�� ��� (�Ե����丮���� :202204 )
		        		dam_amt =  FineDocDb.getDamAmtRate(cltr_rat, amt4);  
		    } else if (  bank_id.equals("0033") || bank_id.equals("0029")    ) {		// ��������(0033) , ��������(0029) - ���� ���� 120%
	        		dam_amt =  FineDocDb.getDamAmtRate(120, amt4);
		    } else if (  bank_id.equals("0028")  ) {		// ��������(0028) - ���� ���� 110%
        		dam_amt =  FineDocDb.getDamAmtRate(110, amt4); 		  
			} else if  ( bank_id.equals("0064")    )  {  //�޸���  - ����� õ�������� ����			
			        dam_amt =  FineDocDb.getDamAmt4(amt4+amt5, 3);			   		 
			} else if  ( bank_id.equals("0065")  ||  bank_id.equals("0038")  ||  bank_id.equals("0057") )  {  //��ȭ������ - ����� 100% , ktĳ��Ż(100% - 20140724), �Ե�ĳ��Ż(0038>20140820 100%)  , ibkĳ��Ż(0057, 50���ѵ�������, 202012)
			         dam_amt =  amt4;	
		//	} else if  ( bank_id.equals("0028")    )  {  //�ϳ��������� , ����(20170412) - ��������  100%
		//	         dam_amt =  amt3;		
			} else if  ( bank_id.equals("0078")  || bank_id.equals("0080")  || bank_id.equals("0087") ||  bank_id.equals("0103") )  {  //kbĳ��Ż(0078) �㺸 10% , ����������(0080), �����̾�����(0087), IBKĳ��Ż(0057) , kb����ī��(0103)
		             dam_amt =	 (amt4 + amt5) /10 ;		          
		    } else if (  bank_id.equals("0001") ||  bank_id.equals("0046") ) { //�ϳ�����/		   //�츮ī��(0046)/   
		    	dam_amt =  FineDocDb.getDamAmtRate(60, amt4);  //2022-01-25  ���� (�������)
		      //  	  dam_amt =  amt6;		    				           	         
		    } else if (  bank_id.equals("0083") ) { //������������
          	       	 dam_amt =  FineDocDb.getDamAmt7(amt3);		  
		    } else if (  bank_id.equals("0115") ) { //��ȭ��������
     	       	 dam_amt =  FineDocDb.getDamAmtRound4(amt3, 30);
		    } else if (  bank_id.equals("0087") ) { //kb��������
      	       	  	 dam_amt =  FineDocDb.getDamAmt10(amt3);            
            } else if (  bank_id.equals("0089") || bank_id.equals("0111") ) { //�μ����� , ��ȭ����(0111)
          	       	 dam_amt =  FineDocDb.getDamAmt11(amt3);          	
          	} else if (  bank_id.equals("0076") || bank_id.equals("0081") ||  bank_id.equals("0074")  ||  bank_id.equals("0090")   ) {		//, aj�κ���Ʈ	- ���԰��� 50%  	  
          		     dam_amt =  FineDocDb.getDamAmt2(amt3);            
            } else {
                    dam_amt = 	 (amt4 + amt5) /2 ;
            } 
                 		                 		
              //   System.out.println("����ݾ� �Ǻ� �����㺸="+ bank_id + ":"  + (amt4 + amt5) /5  );	
                           		 
		if(!FineDocDb.updateFineDocAmt4(doc_id, seq_no,  amt3,  amt4, amt5, dam_amt))	count += 1;		
				
	}

	
//	flag = FineDocDb.updateFineDocList(doc_id, gov_id);			
	
	if(cmd.equals("d")){

		FineDocListBn.setDoc_id(doc_id);
		FineDocListBn.setRent_l_cd(rent_l_cd);
		
		cnt = FineDocDb.bank_doc_list_del(FineDocListBn);

	}
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<script>
<% if(!cmd.equals("d")){%>
<%		if(count != 0){%>
		alert("�����߻�!");
<% } else {%>	
		alert("���������� ó���Ǿ����ϴ�.");
		parent.opener.location.reload();
		parent.window.close();	

<%		}%>

<%}else{%>
<% if(cnt != 0){%>
		alert("�Ѱ� ���� �Ǿ����ϴ�.");
		parent.parent.location.reload();
<%}else{%>
		alert("���� ���� ����");
<%}
}%>

</script>
</body>
</html>

