<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_samt.*" %>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>

<script language='JavaScript' src='/include/common.js'></script>

<script language="JavaScript">
<!--
	
-->
</script>

<style>
        * {
            box-sizing: border-box;
            -moz-box-sizing: border-box;
            -webkit-box-sizing: border-box;
        }
				table, table td{
					border:1px solid #000;
				}
    </style>
</head>

<body>
<form  name="form1"  method="POST">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"3":request.getParameter("gubun1");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_day = request.getParameter("s_day")==null?"":request.getParameter("s_day");
			
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");

	String acct = request.getParameter("acct")==null?"000620":request.getParameter("acct");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CusSamt_Database cs_db = CusSamt_Database.getInstance();

	String acct_nm = "";
	
	if (acct.equals("000620")) {
		acct_nm = "MJ���ͽ�";
	} else if ( acct.equals("002105")  ) {
		acct_nm = "�ΰ��ڵ�������";
	} else if ( acct.equals("000286")  ) {
		acct_nm = "��������";	
	} else if ( acct.equals("006858")  ) {
		acct_nm = " ����ũ��";		
//	} else if ( acct.equals("007603")  ) {
//		acct_nm = " �����";			
	} else if ( acct.equals("001816")  ) {
		acct_nm = " ��������";
	} else if ( acct.equals("007897")  ) {
		acct_nm = " 1�ޱ�ȣ�ڵ�������";	
	} else if ( acct.equals("008462")  ) {
		acct_nm = " ������������";	
	} else if ( acct.equals("008507")  ) {
		acct_nm = " ����������";			
	} else if ( acct.equals("006490")  ) {
		acct_nm = " ��1��";				
	} else if ( acct.equals("009290")  ) {
		acct_nm = " �ſ����̸��ͽ�";					
	} else if ( acct.equals("010424")  ) {
		acct_nm = " �������뼭��";						
	} else if ( acct.equals("002033")  ) {
		acct_nm = " �������������ڵ���";						
	} else if ( acct.equals("010757")  ) {
		acct_nm = " SNP���ͽ�";	
	} else if ( acct.equals("010779")  ) {
		acct_nm = " ����ũ���� ";			
	} else if ( acct.equals("010651")  ) {
		acct_nm = " �������ͽ� ";	
	} else if ( acct.equals("012005")  ) {
		acct_nm = " �Ƹ������ͽ� ";		
	} else if ( acct.equals("012730")  ) {
		acct_nm = " �������� ";			
	} else {
		acct_nm = "����ī��ũ";
	}	
	
	long r_labor = 0;
	
	String jungsan = "";
	String chk_jungsan = "";
	
	String s_set_dt = "";
	String s_jung_st = "";
	
	String s_yy		 = "";
	String s_mm		 = "";
		
	int ii = 0;
	int kk =0;
	String value[] = new String[2];
	boolean header = false;

%>

<input type='hidden' name='acct' value='<%=acct%>'>

<%
Vector sers = cs_db.getServNewJList(acct, "3", s_year, s_mon, s_day, s_kd, t_wd, sort, asc);

int ser_size = sers.size();
	
long amt[] 	= new long[13];

long t_vat2 = 0;
long vat2 = 0;

for(int i = 0 ; i < ser_size ; i++){
	
	 Hashtable exp = (Hashtable)sers.elementAt(i);
	 
	 jungsan = String.valueOf(exp.get("SS_DT")) +"^"+ String.valueOf(exp.get("SSS_ST"));  //������/����ȸ��
	 
	 kk++;
	 
	 if (i==0) { 
		 chk_jungsan = jungsan;
		 header = true;		
	 }
			 
	StringTokenizer st = new StringTokenizer(jungsan,"^");
	int s=0;
	
	while(st.hasMoreTokens()){
		value[s] = st.nextToken();
		s++;
	}
	
	s_set_dt	= value[0];
	s_jung_st	= value[1];
						
	s_yy = s_set_dt.substring(0,4);
	s_mm = s_set_dt.substring(4,6);	
		 
	if (  !chk_jungsan.equals(jungsan) ) {	
		 //header = true;	 	
		// System.out.println("chk_jungsan="+ chk_jungsan + " vat2="+ vat2);		 
		 vat2 = vat2*10/100;  		 
		 vat2  =AddUtil.l_th_rnd_long(vat2);	
		 t_vat2=t_vat2 + vat2;
	//	 System.out.println("vat2="+ vat2 + " t_vat2="+ t_vat2);    
				 
		 vat2 = 0;
		 chk_jungsan = jungsan;   
	 }
%>
   	 
<% // header ���
   if ( header ) {	
	   ii++;
	   kk=0;    
%> 

<hr>	
<table class="" border="0" cellspacing="0" cellpadding="0" width=1462  id='tbl<%=ii%>'>
  <tr> 
    <th colspan="18" align="left"><font face="����" size="2"  > 
      <b>&nbsp; * &nbsp;<%=acct_nm%>&nbsp;�ŷ���Ȳ ( <%=s_year%>��&nbsp;<%=s_mon%>��  <%=s_day%>�� ) </b> </font></th>
  </tr>
  <tr> 
    <th colspan="18" align="right"><font face="����" size="1"  > 
      �������: <%=AddUtil.getDate()%>&nbsp;</font>  
   </th>
      
  </tr>
   
   <tr>
            <td width='53'  rowspan=2  align=center style="font-size:9pt;">����</td>
            <td width='95'  rowspan=2  align=center style="font-size:9pt;">������ȣ</td>
            <td width='110' rowspan=2  align=center style="font-size:9pt;">����</td>
            <td width='62'  rowspan=2  align=center style="font-size:9pt;">����</td>
            <td width='61'  rowspan=2  align=center style="font-size:9pt;">�԰�����</td>
	  		<td width='61'  rowspan=2  align=center style="font-size:9pt;">�������</td>
	    	<td width='61'  rowspan=2  align=center style="font-size:9pt;"> �������</td>     
         	<td width='60'  rowspan=2  align=center style="font-size:9pt;">�����</td>
 		    <td width='150' rowspan=2  align=center style="font-size:9pt;">�����</td>			  		
            <td width='190' rowspan=2  align=center style="font-size:9pt;">����</td>
            <td colspan=5 align=center style="font-size:9pt;">���޳���</td>
            <td colspan=2  align=center style="font-size:9pt;">��å��</td>         
            <td width='100'  rowspan=2 align=center style="font-size:9pt;">&nbsp;&nbsp;&nbsp;���&nbsp;&nbsp;&nbsp;</td>
 	</tr>
           
 	<tr>    
            <td width='80'  align=center style="font-size:9pt;">����</font></td>
            <td width='80'  align=center style="font-size:9pt;">��ǰ</font></td>
            <td width='70'  align=center style="font-size:9pt;">D/C</font></td>
            <td width='70'  align=center style="font-size:9pt;">���Ա�</font></td>
            <td width='80'  align=center style="font-size:9pt;">�Ұ�</font></td>
            <td width='70'  align=center style="font-size:9pt;">û��</font></td>
            <td width='70'  align=center style="font-size:9pt;">������</font></td>               
 	</tr>
 
<% 
	header = false;
	chk_jungsan = jungsan;   
	
   } 
%>   
  
     <tr>  
                <td width='53' align='center' style="font-size : 9pt;"><%=kk+1%>
                <%if(exp.get("USE_YN").equals("N")){%>
              	(�ؾ�) 
              	<%}%>
                </td>
                <td width='95' align='center' style="font-size : 9pt;">&nbsp;<%=exp.get("CAR_NO")%></td>
                <td width='110' align='left' style="font-size : 9pt;">&nbsp;<%=Util.subData(String.valueOf(exp.get("CAR_NM")), 9)%></td>
                <td width='62' align='center' style="font-size : 9pt;"><%=exp.get("SERV_ST")%></td> 
                <td width='61'  align=center   style="font-size : 9pt;"><%=exp.get("IPGODT")%></td>
                <td width='61'  align=center  style="font-size : 9pt;"><%=exp.get("CHULGODT")%></td>
                <td width='61' align=center   style="font-size : 9pt;"><%=exp.get("REG_DT")%></td>      
             <%
					// ���� ��� ���Ǻ���
				 int our_fault = 0;
				 String ch_fault = "";
				 String ch_acc_st = "";
				 
				 String o_fault= cs_db.getOutFaultPer( (String)exp.get("CAR_MNG_ID"), (String)exp.get("ACCID_ID"));
				
				 StringTokenizer token2 = new StringTokenizer(o_fault,"^");
				
				 while(token2.hasMoreTokens()) {
						ch_fault = token2.nextToken().trim();	 
						ch_acc_st = token2.nextToken().trim();	 			
				 }
				 our_fault = AddUtil.parseInt (ch_fault);
				 
				 //�Ҽ��ΰ�� �Ҽ��� ��������� 
				 if ( !String.valueOf(exp.get("J_FAULT_PER")).equals("0") )  { 
					 our_fault =  AddUtil.parseInt(String.valueOf(exp.get("J_FAULT_PER"))) ;
				 }
				 
				 long v_amt = AddUtil.parseLong((String)exp.get("AMT")); //��ǰ
				 
					 
				 if ( exp.get("SERV_ST").equals("����")){   			
				        v_amt = v_amt * our_fault/100;   				 
				 }  
				 
				  //�ϴ��� ����   -20120223
				   v_amt  =AddUtil.l_th_rnd_long(v_amt);
				 
				 long v_labor = AddUtil.parseLong((String)exp.get("LABOR")); //����
				 
			 	 long v_dc_sup_amt = AddUtil.parseLong((String)exp.get("DC_SUP_AMT")); //����
				 
				 v_dc_sup_amt  =AddUtil.l_th_rnd_long(v_dc_sup_amt);
				   
				  
				if ( exp.get("SERV_ST").equals("����")){   		
				        v_labor = v_labor * our_fault/100;
				
   				 }  
			   	 
				 long v_c_labor = AddUtil.parseLong((String)exp.get("A_LABOR")); //���� ���� ���� :õ����:dc���� 1~2õ����:10% 2~3õ����:15%, 3õ�����̻�:20%
				 
				 
				 int v_cnt =  AddUtil.parseInt((String)exp.get("CNT"));
				 
				 long v_cust_amt =  AddUtil.parseLong((String)exp.get("CUST_AMT"));
				
				 long v_ext_amt =  AddUtil.parseLong((String)exp.get("EXT_AMT"));
				 
				  long v_cls_amt =  AddUtil.parseLong((String)exp.get("CLS_AMT"));
				 
				 StringTokenizer token1 = new StringTokenizer((String)exp.get("ITEM"),"^");
				 
				 String item1 = "";
				 String item2 = "";
				   
			     while(token1.hasMoreTokens()) {
				
				  	 item1 = token1.nextToken().trim();	//
				   	 item2 = token1.nextToken().trim();	//��ǰ
								
			     }	
			     			     
			    //���� ���� ���� :õ����:dc���� 1~2õ����:10% 2~3õ����:15%, 3õ�����̻�:20%
				  
			    if  ( i == 0 ) {
			   		amt[8]   = v_c_labor + v_labor ;	
			   	}else {
			   		amt[8]  = amt[8]  + v_labor;	
			   	}
			   
			    int c_rate = 0;
			    int vc_rate = 0;
				int jj_amt = 0;
				int jjj_amt = 0;
				   			 
				long s_dt = 	AddUtil.parseLong(String.valueOf(exp.get("SS_DT")));
				    
			    r_labor = AddUtil.l_th_rnd_long(  v_labor - vc_rate);
			    			     
			%>
          
                <td width='60' align='center' style="font-size : 9pt;">&nbsp;<%=c_db.getNameById(String.valueOf(exp.get("CHECKER")), "USER")%></td>			  
			  	<td width='150' align='left' style="font-size : 9pt;">&nbsp;<%=Util.subData(String.valueOf(exp.get("CLIENT_NM")), 10)%></td>
  			    <td width='190' align='left' style="font-size : 9pt;">&nbsp;
  			    <%if(String.valueOf(exp.get("CNT")).equals("1")){%>
  			    <%=item2 %>
			  	<%}else{%>
			   <%=Util.subData(item2, 10)%>&nbsp;�� <%= AddUtil.parseDecimal(v_cnt - 1)%>&nbsp;��		  
			  	<%}%></td>
                <td width='80' align='right' style="font-size : 9pt;"><%=AddUtil.parseDecimal(r_labor)%></td>
                <td width='80' align='right' style="font-size : 9pt;"><%=AddUtil.parseDecimal(v_amt)%></td>
                <td width='70' align='right' style="font-size : 9pt;"><%=AddUtil.parseDecimal(v_dc_sup_amt)%></td>
                <td width='70' align='right' style="font-size : 9pt;"><%=AddUtil.parseDecimal(v_ext_amt)%></td>
                <td width='80' align='right' style="font-size : 9pt;"><%=AddUtil.parseDecimal(r_labor + v_amt - v_dc_sup_amt - v_ext_amt)%></td>           
                <td width='70' align='right' style="font-size : 9pt;"><%=AddUtil.parseDecimal(exp.get("CUST_AMT"))%></td>          
                <td width='70' align='right' style="font-size : 9pt;"><%=AddUtil.parseDecimal(exp.get("CLS_AMT"))%></td>          
                <td width='100' align='right' style="font-size : 9pt;">&nbsp;</td>    
	</tr>  
   
<%	
               
             		amt[0]   = amt[0] + AddUtil.l_th_rnd_long( v_labor );
             		amt[1]   = amt[1] + v_amt;
             		amt[2]   = amt[2] + v_amt + v_labor;
             		amt[3]   = amt[3] + vc_rate;
             		
             		amt[4]   = amt[4] +r_labor;
             		amt[5]   = amt[5] + v_amt;
             		amt[6]   = amt[6] + r_labor + v_amt - v_dc_sup_amt - v_ext_amt;
             		amt[7]   = amt[7] + v_cust_amt;
             		amt[10]   = amt[10] + v_ext_amt;
             		amt[11]   = amt[11] + v_dc_sup_amt;
             		
             		amt[12]   = amt[12] + v_cls_amt;
             		
             		//ȸ���� vat ���� ��� 
             		vat2    = vat2  + r_labor + v_amt - v_dc_sup_amt - v_ext_amt;
             	      
    }

	//System.out.println("chk_jungsan="+ chk_jungsan + " vat2="+ vat2);	
	vat2 = vat2*10/100;  	
	vat2  =AddUtil.l_th_rnd_long(vat2);	
	t_vat2=t_vat2 + vat2;
	//System.out.println("vat2="+ vat2 + " t_vat2="+ t_vat2);   
 
%>
     <tr> 
         <td class=star colspan=10 align='center' style="font-size : 9pt;">�հ�</td>
         <td  width='80' class=star align='right' style="font-size : 9pt;"><%=Util.parseDecimal(amt[4] )%></font></td>
         <td  width='80' class=star align='right' style="font-size : 9pt;"><%=Util.parseDecimal(amt[5] )%></font></td>
        <td  width='70' class=star align='right' style="font-size : 9pt;"><%=Util.parseDecimal(amt[11] )%></font></td>
        <td width='70' class=star align='right' style="font-size : 9pt;"><%=Util.parseDecimal(amt[10] )%></font></td>
         <td width='80' class=star align='right' style="font-size : 9pt;"><%=Util.parseDecimal(amt[6] )%></font></td>           
         <td width='70' class=star align='right' style="font-size : 9pt;"><%=Util.parseDecimal(amt[7] )%></font></td>
        <td width='70' class=star align='right' style="font-size : 9pt;"><%=Util.parseDecimal(amt[12] )%></font></td>
         <td width='100' align='right' style="font-size : 9pt;">&nbsp;vat:&nbsp;<%=Util.parseDecimal(t_vat2)%></font></td>
       </tr>
<hr />
  
</table>
</form>
</body>
</html>