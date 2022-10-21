<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

    String s_user =  request.getParameter("s_month")==null?"":request.getParameter("user_id");	
   
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");	
   
   	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID			
	if(user_id.equals(""))	user_id = ck_acar_id;
	
    String dt		= "4";

	int cnt = 3; //��Ȳ ��� �Ѽ�
	int sh_height = cnt*sh_line_height;
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
		
//����ķ���κ��� : cost_campaign ���̺�
	Hashtable ht3 = ac_db.getCostCampaignVar("5");
	
	String year 		= (String)ht3.get("YEAR");
	String tm 			= (String)ht3.get("TM");
	String cs_dt 		= (String)ht3.get("CS_DT");
	String ce_dt 		= (String)ht3.get("CE_DT");

	int amt1 			= AddUtil.parseInt((String)ht3.get("AMT1"));  //��������
	int amt1_per 		= AddUtil.parseInt((String)ht3.get("AMT1_PER")); //����  ������� (�λ�����)
	int amt2 			= AddUtil.parseInt((String)ht3.get("AMT2"));  // ���������򰡱ݾ�	
	int amt3 			= AddUtil.parseInt((String)ht3.get("AMT3"));  //�������
		
	int cam_per 		= AddUtil.parseInt((String)ht3.get("CAM_PER"));  //ķ��������� �������
					
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDt("stat_bus_prop");
		
	Vector vts2 = ac_db.getPropCampaign(save_dt, "5", "", "", "");
	int vt_size2 = vts2.size(); 
	long ave_amt = 0;
			
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--


//�˾������� ����
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}	

//��������
function updateVar(t_chk){
	var fm = document.form1;
	if(!confirm("�������� �����Ͻðڽ��ϱ�?"))	return;	
	fm.action = "/fms2/mis/prop_var_iu.jsp?t_chk="+t_chk;
	fm.target = 'i_no';
	fm.submit();
}

//���ĺ���
function view_sik(){
	window.open("man_cost_jung.jsp?popup=Y","sik","left=100,top=50,width=950,height=500,scrollbars=yes");
}

//����Ʈ�ϱ�
function cmp_print(){
	window.open("prop_settle_print.jsp?save_dt=<%=save_dt%>&auth_rw=<%=auth_rw%>","print","left=30,top=50,width=950,height=600,scrollbars=yes");	
}

//-->
</script>
</head>

<body>
<form action="" name="form1" method="POST">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>"> 
<input type="hidden" name="gubun" value="5"> 
<input type="hidden" name="from_page" value="/fms2/mis/prop_settle.jsp"> 
<input type="hidden" name="save_dt" value="<%=save_dt%>"> 
<input type="hidden" name="year" value="<%=year%>"> 
<input type="hidden" name="tm" value="<%=tm%>"> 
<input type="hidden" name="o_cs_dt" 	value="<%=cs_dt%>">
<input type="hidden" name="o_ce_dt" 	value="<%=ce_dt%>">
<table width="900" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�濵���� > ķ���ΰ��� > <span class=style5>����ķ����(����)</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_campaign.gif align=absmiddle>&nbsp;
        <input type="text" name="ccs_dt" size="11" value="<%= AddUtil.ChangeDate2(cs_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
        ~ 
        <input type="text" name="cce_dt" size="11" value="<%= AddUtil.ChangeDate2(ce_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'></td>
    </tr>
</table>
<table width="900" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><div align="right"><img src=/acar/images/center/arrow_gjij.gif align=absmiddle> : <%=AddUtil.ChangeDate2(save_dt)%></div></td>
    </tr>
</table>
 
<table width="900" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
 	  <td class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width='900'>
         <tr> 
           <td width='40' class='title' rowspan=2>����</td>
           <td width='90' class='title' rowspan=2>�μ�</td>
           <td width='70' class='title' rowspan=2>����</td>
           <td class='title' colspan=6 >���ȳ���</td>
           <td width='100' class='title' rowspan=2>���� </td>	
           <td width='90' class='title' rowspan=2>����<br>�ݾ�</td>	
           <td width="200" rowspan="2">
        	     <table width="100%" border="0" cellspacing="0" cellpadding="0">
        	     <tr style='text-align:right'>
        		  <td class="title_p" width="200" style='height:44; text-align=center;'>�׷���</td>
        	    </tr>
          </table>
        	</td>
          </tr>
          <tr> 
           <td  width="55" class='title' >����<br>�Ǽ�</td>
           <td  width="55" class='title' >ä��<br>�Ǽ�</td>
           <td  width="60" class='title' >����<br>����</td>
           <td  width="70" class='title' >��������<br>�򰡱ݾ�</td>
           <td  width="60" class='title' >���<br>�Ǽ�</td>
           <td  width="60" class='title' >���<br>����</td>
          </tr>
       
	  
<%	if(vt_size2 > 0){
	   
     	long t_cnt1[] = new long[1]; //���ȰǼ�	
    	long t_cnt2[] = new long[1]; //ä�ü���
   	long t_cnt3[] = new long[1]; //�ǰ߰Ǽ�
   		
      	long t_amt1[] = new long[1]; //ä�ñݾ�
      	long t_amt2[] = new long[1]; //����ݾ�
      	long t_amt3[] = new long[1]; //��������
      	long t_amt4[] = new long[1]; //�������
    
	long t_ave_amt = 0;
	    
    	long cam_amt = 0;	
    	long cam_amt1 = 0;	
   	long sum_cam_amt = 0;	
   
     	for(int i = 0 ; i < vt_size2 ; i++){
				Hashtable ht = (Hashtable)vts2.elementAt(i);
							
				for(int j=0; j<1; j++){
							
					t_cnt1[j] += AddUtil.parseLong(String.valueOf(ht.get("CNT1")));	 //���ȰǼ�	
					t_cnt2[j] += AddUtil.parseLong(String.valueOf(ht.get("CNT2")));	 //ä�ü���
					t_cnt3[j]  += AddUtil.parseLong(String.valueOf(ht.get("CNT3"))); //�ǰ߰Ǽ�
					t_amt1[j]  += AddUtil.parseLong(String.valueOf(ht.get("P_AMT"))) ; //ä�ñݾ�
					t_amt2[j]  += AddUtil.parseLong(String.valueOf(ht.get("R_AMT"))) ; //������
					t_amt3[j]  += AddUtil.parseLong(String.valueOf(ht.get("E_AMT"))) ; //��������
					t_amt4[j]  += AddUtil.parseLong(String.valueOf(ht.get("C_AMT"))) ; //�������
					cam_amt	   += AddUtil.parseLong(String.valueOf(ht.get("PP_AMT"))) ; //ķ���αݾ�						  
				}	
		}   		  				   
   		   
   		ave_amt = t_amt2[0]/vt_size2;
   		ave_amt =   AddUtil.ml_th_rnd((int)ave_amt);
   		
        for(int i = 0 ; i < vt_size2 ; i++){
				Hashtable ht = (Hashtable)vts2.elementAt(i);
									
				cam_amt1 = AddUtil.parseLong(String.valueOf(ht.get("R_AMT")));   	
		 		  		           		
		   		float graph = 300;
		   		float  g1 = (float) cam_amt1 / 10000;
		 
 %>   		
	      <tr> 
	         <input type='hidden' name='bus_id' value='<%= ht.get("USER_ID") %>'>
	         <input type='hidden' name='p_amt' value='<%=cam_amt%>'>
	      	 <td align="center" ><%= i+1%></td>
	         <td align="center" ><%=ht.get("DEPT_NM")%>&nbsp;</td>
	         <td align="center" ><%=ht.get("USER_NM")%>&nbsp;
	         <% if (user_id.equals((String)ht.get("USER_ID")) || user_id.equals("000063") ) {%> 
	          <a href="javascript:MM_openBrWindow('prop_settle_detail_list.jsp?mng_id=<%= ht.get("USER_ID") %>&dt=<%=dt%>&ref_dt1=<%=cs_dt%>&ref_dt2=<%=ce_dt%>&mng_nm=<%=ht.get("USER_NM")%>&amt1=<%=amt1%>&amt2=<%=amt2%>&amt1_per=<%=amt1_per%>','popwin_list','scrollbars=yes,status=no,resizable=yes,width=800,height=500,top=30,left=30')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="����Ʈ����"></a>
             <% } %>        
	         </td>
	         <td align="right" ><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("CNT1"))))%></td>
	         <td align="right" ><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("CNT2"))))%></td>
	      
	         <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("E_AMT"))))%></td>    		
	         <td align="right" ><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("P_AMT"))))%></td>
	            <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("CNT3"))))%></td>    		
	         <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("C_AMT"))))%></td>    		
	         <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("R_AMT"))))%></td>
	         <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("PP_AMT"))))%></td>
	         </td>    
	         <td align="">
	          <table width="200" border="0" cellspacing="0" cellpadding="0">
         
		         <tr>
		           	<td width=200><img src=../../images/result1.gif width=<%=g1%> height=10></td>	
		       	 </tr>

	       	 </table>        
	      </tr>
	       <% 	} %> 
	      <tr> 
	        <td class=title style='text-align:center;' colspan=3>�հ�</td>
	        <td class=title style='text-align:right;'><%= Util.parseDecimal(t_cnt1[0])%></td>
	        <td class=title style='text-align:right;'><%= Util.parseDecimal(t_cnt2[0])%></td>	   
	      
	        <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt3[0])%></td>
	        <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt1[0])%></td>
	          <td class=title style='text-align:right;'><%= Util.parseDecimal(t_cnt3[0])%></td>
	        <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt4[0])%></td>
	        <td class=title style='text-align:right;'>*���:<%= Util.parseDecimal(ave_amt)%></td>
	         <td class=title style='text-align:right;'><%= Util.parseDecimal(cam_amt)%></td>
	        <td class=title style='text-align:right;'>&nbsp;</td>
	      </tr>		
         
<%	}else{%>   
                  
  <tr>
	  <td> 
	   <table width="900" border="0" cellspacing="0" cellpadding="0">
          <tr>
		  <td>��ϵ� ����Ÿ�� �����ϴ�</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>

   </table>
    </td>
  </tr>
</table>
<br>
<!-- �򰡱��� -->
  <table width="900" border="0" cellspacing="0" cellpadding="0">
  	<tr> 
      <td colspan=2><font color="#999999"><font color="#FF00FF">�� ������</font>       : ���Ƚɻ簡 �Ϸ�� ������  �������� �����˴ϴ�.  
        &nbsp;&nbsp;</td>
   	</tr> 
 
    <tr> 
      <td width="110">&nbsp;&nbsp;&nbsp;1. �򰡱��رⰣ</td>
      <td>: 
        <input type="text" name="cs_dt" size="11" value="<%= AddUtil.ChangeDate2(cs_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
		~
		<input type="text" name="ce_dt" size="11" value="<%= AddUtil.ChangeDate2(ce_dt) %>" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
	 </td>
	</tr>
    <% if ( auth_rw.equals("6") || auth_rw.equals("4") ) { %> 
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;2. �������</td>
      <td>: 
       	��������*<input type="text" name="amt1" size="10" value="<%= AddUtil.parseDecimal(amt1) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
		��&nbsp;+&nbsp;�������*<input type="text" name="amt3" size="10" value="<%= AddUtil.parseDecimal(amt3) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>��
	  </td>	
    </tr>
 
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;3. ����ȿ��</td>
      <td>:
               ���� *<input type="text" name="amt1_per" size="3" value="<%= AddUtil.parseDecimal(amt1_per) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
       %,&nbsp;����ݾ�  *<input type="text" name="cam_per" size="3" value="<%= AddUtil.parseDecimal(cam_per) %>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
       % �ݿ�.       
      </td>
    </tr>
   <% } %>
   </table>  

<% if ( auth_rw.equals("6") || auth_rw.equals("4") ) { %> 
   <table width="900" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td align=right><a href='javascript:updateVar(1)' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify_bs.gif"  align="absmiddle" border="0"></a>
      <%if(nm_db.getWorkAuthUser("������",user_id)){%>
	      &nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:cmp_print()' title='����Ʈ�ϱ�'><img src=/acar/images/center/button_print.gif align=absmiddle border=0></a>
	  <%}%>
	  
      </td>
    </tr>
  </table>
<% } %>  

</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>

</script>		
</body>
</html>

