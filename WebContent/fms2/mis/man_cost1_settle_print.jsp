<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.common.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
 	String s_user =  request.getParameter("s_month")==null?"":request.getParameter("user_id");	
   
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");	
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
    String dt		= "4";

	int cnt = 3; //��Ȳ ��� �Ѽ�
	int sh_height = cnt*sh_line_height;
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	
//���ķ���κ��� : cost_campaign ���̺�
	Hashtable ht3 = ac_db.getCostCampaignVar("1");  //
	
	String year 		= (String)ht3.get("YEAR");
	String tm 			= (String)ht3.get("TM");
	String cs_dt 		= (String)ht3.get("CS_DT");
	String ce_dt 		= (String)ht3.get("CE_DT");

	int amt1 			= AddUtil.parseInt((String)ht3.get("AMT1"));  //�Ϲ������ �ѵ�
	int amt1_per 		= AddUtil.parseInt((String)ht3.get("AMT1_PER")); //�ѵ�
	int amt2 			= AddUtil.parseInt((String)ht3.get("AMT2"));  //�������� �ѵ�
	int amt2_per 		= AddUtil.parseInt((String)ht3.get("AMT2_PER")); //�ѵ�
	int amt3 			= AddUtil.parseInt((String)ht3.get("AMT3"));
	int amt3_per		= AddUtil.parseInt((String)ht3.get("AMT3_PER")); //�������� ������
	int rent_way_1_per 		= AddUtil.parseInt((String)ht3.get("RENT_WAY_1_PER"));
	int rent_way_2_per 	= AddUtil.parseInt((String)ht3.get("RENT_WAY_2_PER"));
	int max_day			= AddUtil.parseInt((String)ht3.get("MAX_DAY"));
	
	int cam_per 		= AddUtil.parseInt((String)ht3.get("CAM_PER"));
	int a_cam_per 		= AddUtil.parseInt((String)ht3.get("A_CAM_PER"));
	
	int cc1 			= AddUtil.parseInt((String)ht3.get("CC1"));
	int cc2	 			= AddUtil.parseInt((String)ht3.get("CC2"));
	int cc3 			= AddUtil.parseInt((String)ht3.get("CC3"));
	int cc4 			= AddUtil.parseInt((String)ht3.get("CC4"));
	
	int da_amt1 		= AddUtil.parseInt((String)ht3.get("DA_AMT1"));
	int da_amt2 		= AddUtil.parseInt((String)ht3.get("DA_AMT2"));
	int da_amt3 		= AddUtil.parseInt((String)ht3.get("DA_AMT3"));
		
	int bus_cost_per 		= AddUtil.parseInt((String)ht3.get("BUS_COST_PER"));
	int mng_cost_per 		= AddUtil.parseInt((String)ht3.get("MNG_COST_PER"));
		
	int car_cnt 		= AddUtil.parseInt((String)ht3.get("CAR_CNT"));
	int sale_cnt 		= AddUtil.parseInt((String)ht3.get("SALE_CNT"));	
	int base_cnt 		= AddUtil.parseInt((String)ht3.get("BASE_CNT"));	
		
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDtChk("stat_bus_cost_2_cmp" , "1");
		
	Vector vts2 = ac_db.getCostManCampaignNew2(save_dt, "1", base_cnt, "", "");
	int vt_size2 = vts2.size(); 
	
	
       //����  ��տ�         
	long jb_cnt[] = new long[5];
	long ji_cnt[] = new long[5];
	long ja_amt[] = new long[5];
   	long p_cnt[] = new long[5];
   		   
         for(int i = 0 ; i < vt_size2 ; i++){
		Hashtable ht = (Hashtable)vts2.elementAt(i);				
		//����
		if(String.valueOf(ht.get("DEPT_ID")).equals("0014")) {				 
		 	ji_cnt[0]   +=  AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));  //�Ϲݽ�
		 	jb_cnt[0]  +=  AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT"))); //�⺻��
		 	ja_amt[0] +=  AddUtil.parseLong(String.valueOf(ht.get("R_ONE_PER_COST")));	 //��հ������		 
		 	p_cnt[0]   +=  1;  //�ο�	
		} else  if(String.valueOf(ht.get("DEPT_ID")).equals("0015")) {		 //����		
		 	ji_cnt[1]   +=  AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));  //�Ϲݽ�
		 	jb_cnt[1]  +=  AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT"))); //�⺻��
		 	ja_amt[1] +=  AddUtil.parseLong(String.valueOf(ht.get("R_ONE_PER_COST")));	 //��հ������		
		 	p_cnt[1]   +=  1;  //�ο�	 	
		} else  if(String.valueOf(ht.get("DEPT_ID")).equals("0008")  || String.valueOf(ht.get("DEPT_ID")).equals("0010")) {		 //����/����	
		 	ji_cnt[3]   +=  AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));  //�Ϲݽ�
		 	jb_cnt[3]  +=  AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT"))); //�⺻��
		 	ja_amt[3] +=  AddUtil.parseLong(String.valueOf(ht.get("R_ONE_PER_COST")));	 //��հ������	
		 	p_cnt[3]   +=  1;  //�ο�		 	
		} else  if(String.valueOf(ht.get("DEPT_ID")).equals("0007")  || String.valueOf(ht.get("DEPT_ID")).equals("0011")) {		 //�λ�/�뱸	
		 	ji_cnt[4]   +=  AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));  //�Ϲݽ�
		 	jb_cnt[4]  +=  AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT"))); //�⺻��
		 	ja_amt[4] +=  AddUtil.parseLong(String.valueOf(ht.get("R_ONE_PER_COST")));	 //��հ������
		 	p_cnt[4]   +=  1;  //�ο�			 	
		} else   {		 //�׿�	
		 	ji_cnt[2]   +=  AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));  //�Ϲݽ�
		 	jb_cnt[2]  +=  AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT"))); //�⺻��
		 	ja_amt[2] +=  AddUtil.parseLong(String.valueOf(ht.get("R_ONE_PER_COST")));	 //��հ������	
		 	p_cnt[2]   +=  1;  //�ο�	
	         }	         
      }	
       		       	
       //statement       
	  String query =  "            select  * from ( "+
				  "		select '0' gubun, "+  ja_amt[0] /p_cnt[0] +"  as  a1 ,  " +  ji_cnt[0]  + " as i1 ,  " + jb_cnt[0]  + " as b1,  "+ p_cnt[0] + " as p1  from dual "+
				  "		union  "+
				  "		select '1' gubun, " + ja_amt[1] /p_cnt[1] +"  as  a1  ,  " +  ji_cnt[1]  + " as i1 ,  " + jb_cnt[1]  + " as b1,  "+ p_cnt[1] + " as p1  from dual "+
				  "		union "+
				  "		select '2' gubun,  "+  ja_amt[2] /p_cnt[2] +" as  a1 ,  " +  ji_cnt[2]  + " as i1 ,  " + jb_cnt[2]  + " as b1,  "+ p_cnt[2] + " as p1  from dual "+
				  "		union "+
				  "		select '3' gubun,  " + ja_amt[3] /p_cnt[3] + " as  a1 ,  " +  ji_cnt[3]  + " as i1 ,  " + jb_cnt[3]  + " as b1,  "+ p_cnt[3] + " as p1  from dual "+
				  "		union  "+
				  "		select '4' gubun,  " + ja_amt[4] /p_cnt[4] + " as  a1 ,  " +  ji_cnt[4]  + " as i1 ,  " + jb_cnt[4]  + " as b1,  "+ p_cnt[4] + " as p1  from dual "+
				  "		) b order by gubun asc ";


	Vector vt = c_db.getJspExecuteList(query);
	int vt_size = vt.size();
		
	     				
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


//-->
</script>
</head>

<body>
<form action="" name="form1" method="POST" target="popuptarget">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>"> 
<input type="hidden" name="gubun" value="1"> 
<input type="hidden" name="from_page" value="/fms2/mis/man_cost1_settle.jsp"> 
<input type="hidden" name="save_dt" value="<%=save_dt%>"> 
<input type="hidden" name="year" value="<%=year%>"> 
<input type="hidden" name="tm" value="<%=tm%>">  
<input type="hidden" name="amt2" value="<%=amt2%>"> 
<input type="hidden" name="amt2_per" value="<%=amt2_per%>">  
<input type="hidden" name="a_cam_per" value="<%=a_cam_per%>">  
<input type="hidden" name="o_cs_dt" 	value="<%=cs_dt%>">
<input type="hidden" name="o_ce_dt" 	value="<%=ce_dt%>">
<input type="hidden" name="bus_cost_per" value="<%=bus_cost_per%>"> 
<input type="hidden" name="mng_cost_per" value="<%=mng_cost_per%>"> 


<table width="900" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�濵���� > ķ���ΰ��� > <span class=style5>�����������ķ����(1�� - ����)</span></span></td>
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
           <td class='title' colspan=3 >ķ���δ��</td>
           <td width='100' class='title' rowspan=2>1��� �����<br>������ </td>
           <td width='100' class='title' rowspan=2>����<br>�ݾ� </td>	
           <td width="320" rowspan="2">
        			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
        				<tr style='text-align:right'>
        				  <td class="title_p" width="320" style='height:44; text-align=center;'>�׷���</td>
        				</tr>
        			  </table>
        	</td>
          </tr>
          <tr> 
           <td  width="60" class='title' >�⺻��</td>
           <td  width="60" class='title' >�Ϲݽ�</td>
           <td  width="60" class='title' >�Ұ�</td>
          </tr>
       
	  
<%	if(vt_size2 > 0){
	   
     	long t_cnt[] = new long[1];
    	long i_cnt[] = new long[1];
   		long b_cnt[] = new long[1];
   	
	    long bb_cnt = 0;
	    long ii_cnt = 0 ;
	    long cc_amt = 0 ;
	    
	    long s_tot = 0;
	    long g_tot = 0;
	    long ccnt  = 0;
	
	    long ave_amt1 = 0;
	    long ave_amt2 = 0;
	    long t_ave_amt = 0;
	               
	    long ac_amt = 0;
	    long a_amt = 0;
	    long ea_amt = 0;
    	
    	long cam_amt = 0;	
   		long sum_cam_amt = 0;	       
     
   		   
        for(int i = 0 ; i < vt_size2 ; i++){
				Hashtable ht = (Hashtable)vts2.elementAt(i);
						
				ii_cnt = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));
				bb_cnt = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT")));
				
				for(int j=0; j<1; j++){
											
					i_cnt[j] += ii_cnt;
					b_cnt[j] += bb_cnt;
				}				
						
			    // ��ǰ��������� ������ 1�����
			    t_ave_amt = AddUtil.parseLong(String.valueOf(ht.get("ONE_PER_COST")));
			    ave_amt2 =  AddUtil.parseLong(String.valueOf(ht.get("R_ONE_PER_COST")));
			    cam_amt  =  AddUtil.parseLong(String.valueOf(ht.get("P_AMT")));
			    
			    if ( ht.get("PO").equals("9") )    	cam_amt = 0;
			    			         
		   	 	sum_cam_amt +=cam_amt; 
   		   		float graph = 160;
		   		float  g1 = (float) ave_amt2*160 / t_ave_amt;
		   			  		
		  		if (ave_amt2 > t_ave_amt ) {
		  			   graph =  g1  - 160;
		  //		   System.out.println("graph1=" +graph);
		  		} else {
		  			  graph =  160 - g1;
		  	//	  System.out.println("graph1=" +graph);
		  		}
		  		
		  	//	if (ave_amt2 > t_ave_amt ) {
		  	
		  	   //max:160 
		  		  if (graph >= 160) {
		  		  	graph = 160;
		  	//	  	System.out.println("graph2=" +graph);
		  		  }
		  	 //  	}	
		  	   	
		  	   		   		
		   		//result1: ������ resul2:�Ķ��� result3:���		   				  				   		
	//	   		System.out.println("ave_amt2= " + ave_amt2 + " g1= " +g1 + " g2 =   graph= " + graph); 	
	
	 	

 %>   		
	      <tr> 
	         <input type='hidden' name='bus_id' value='<%= ht.get("USER_ID") %>'>
	         <input type='hidden' name='p_amt' value='<%=cam_amt%>'>
	      	 <td align="center" ><%= i+1%></td>
	         <td align="center" ><%=c_db.getNameById(String.valueOf(ht.get("DEPT_ID")), "DEPT")%>&nbsp;</td>
	         <td align="center" ><%=ht.get("USER_NM")%>&nbsp;</td>
	         <td align="right" ><%=bb_cnt%>&nbsp;</td>
	         <td align="right" ><%=ii_cnt%>&nbsp;</td>
	         <td align="right" ><%=bb_cnt + ii_cnt%>&nbsp;</td>
	         <td align="right"><%=Util.parseDecimal(ave_amt2)%>&nbsp;</td>    		
	         <td align="right"><%=Util.parseDecimal(cam_amt)%>&nbsp;</td>
	         </td>    
	   	 <td align="">
	          <table width="320" border="0" cellspacing="0" cellpadding="0">
<% if (!ht.get("PO").equals("9")) {%> 	          
<% if (ave_amt2 > t_ave_amt ) { %>	         
	         <tr>
	         	<td width=160></td>	 
	         	<td width=160><img src=../../images/result1.gif width=<%= graph %> height=10></td>	
	       	 </tr>
<% } else { %>
 		 <tr>
	           	<td width=160><img src=../../images/result3.gif width=<%= g1 %> height=10><img src=../../images/result2.gif width=<%= graph %> height=10></td>	
	         	<td width=160></td>	 
	       	 </tr>
<% } %>	 
<% } else {%>
		 <tr>
	           	<td width=160>������ (���ش�� �̸�)</td>	
	         	<td width=160></td>	 
	       	 </tr>
<% } %>      	 
	       	 </table>        
	      </tr>
	   <% 	} %>

	      <tr> 
	        <td class=title style='text-align:center;' colspan=3>�հ�</td>
	        <td class=title style='text-align:right;'><%= Util.parseDecimal(b_cnt[0])%><br><%= Util.parseDecimal(b_cnt[0]/vt_size2)%></td>
	        <td class=title style='text-align:right;'><%= Util.parseDecimal(i_cnt[0])%><br><%= Util.parseDecimal(i_cnt[0]/vt_size2)%></td>
	        <td class=title style='text-align:right;'><%= Util.parseDecimal(b_cnt[0] + i_cnt[0])%><br><%= Util.parseDecimal((b_cnt[0] + i_cnt[0]) / vt_size2)%></td>
	        <td class=title style='text-align:right;'><%= Util.parseDecimal(t_ave_amt) %>&nbsp;</td>
	 		<td class=title style='text-align:right;'><%= Util.parseDecimal(sum_cam_amt)%>&nbsp;</td>
	        <td class=title style='text-align:left;'>&nbsp;������ ����</td>
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

 
 <%       
 	 long ih_cnt  = 0;
 	  long bh_cnt  = 0;
 	  long ph_cnt  = 0;
 	  long ah_cnt  = 0;
 	  	 	 	 	 	 
 	 
    	for(int j = 0 ; j < vt_size ; j++){    
   			Hashtable ht1 = (Hashtable)vt.elementAt(j);   
   			
   			 ih_cnt =  AddUtil.parseLong(String.valueOf(ht1.get("I1")));
   			 bh_cnt =  AddUtil.parseLong(String.valueOf(ht1.get("B1")));
   			 ph_cnt =  AddUtil.parseLong(String.valueOf(ht1.get("P1")));
   			 ah_cnt =  AddUtil.parseLong(String.valueOf(ht1.get("A1")));    %>
   			
        <tr> 
	        <td class=title style='text-align:center;' colspan=3>  <% if (String.valueOf(ht1.get("GUBUN")).equals("0")    ) {%>����
	        <%} else if (String.valueOf(ht1.get("GUBUN")).equals("1")    ) {%>����
	        <%} else if (String.valueOf(ht1.get("GUBUN")).equals("2")    ) {%>������
	        <%} else if  (String.valueOf(ht1.get("GUBUN")).equals("3")    ) {%>����&����
	        <%} else if (String.valueOf(ht1.get("GUBUN")).equals("4")    ) {%>�λ�&�뱸
	        <% } %>&nbsp;���
	        </td>
	        <td class=title style='text-align:right;'><%= Util.parseDecimal(bh_cnt/ph_cnt)%>&nbsp;</td>
	        <td class=title style='text-align:right;'><%= Util.parseDecimal(ih_cnt/ph_cnt)%>&nbsp;</td>
	        <td class=title style='text-align:right;'><%= Util.parseDecimal((bh_cnt + ih_cnt) /ph_cnt )%>&nbsp;</td>
	        <td class=title style='text-align:right;'><%= Util.parseDecimal(ah_cnt ) %>&nbsp;</td>
	      <td class=title style='text-align:right;'>&nbsp;</td>
	        <td class=title style='text-align:left;'>&nbsp;</td>
         </tr>	        
   			
  <%} %> 			

   </table>
    </td>
  </tr>
</table>
 
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	set_init();
	
	function set_init(){
		var fm = document.form1;
			   	    
	}	
//-->
</script>		
</body>
</html>

