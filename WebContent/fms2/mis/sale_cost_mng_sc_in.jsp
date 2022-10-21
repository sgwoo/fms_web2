<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="cmp_db" scope="page" class="acar.stat_bus.CampaignDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String mode = request.getParameter("mode")==null?"1":request.getParameter("mode");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	//chrome ���� 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	
   	String save_dt = ad_db.getMaxSaveDt("stat_bus_cmp");
   	String v_year		= "";
	String v_tm		= "";
   	Vector vt = cmp_db.getCampaignList_2012_05_sc2(save_dt, "", "", "");//20120501 ķ���δ�� ����   	
   	//����Ͻ�
	if(vt.size()>0){
		for(int i=0; i<1; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			v_year 	= (String)ht.get("YEAR");
			v_tm 	= (String)ht.get("TM");
		}
	}	
	//����ķ���κ��� : campaign_var ���̺�
	Hashtable ht3 = cmp_db.getCampaignVar(v_year, v_tm, "1"); //1�� ����
	String cs_dt 		= (String)ht3.get("CS_DT");
	String ce_dt 		= (String)ht3.get("CE_DT");
		
	
	
	Vector vts2 = ac_db.getSaleCostCampaignMngList(s_kd, t_wd, sort, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, cs_dt, ce_dt);
	int vt_size2 = vts2.size();
	
	//�縮��/��������ð��ø���Ʈ �����ֱ�
	Vector vts3 = new Vector();
	if(gubun3.equals("4") || gubun3.equals("9")){
		for(int i = 0 ; i < vt_size2 ; i++){
			Hashtable ht2 = (Hashtable)vts2.elementAt(i);
			
			String rent_l_cd = String.valueOf(ht2.get("RENT_L_CD"));
			String max_rent_st = String.valueOf(ht2.get("MAX_RENT_ST"));
			
			Vector vts4 = ac_db.getSaleCostCampaignMngListSub(rent_l_cd, max_rent_st);
			int vt_size4 = vts4.size();
			for(int j = 0 ; j < vt_size4 ; j++){
				Hashtable ht4 = (Hashtable)vts4.elementAt(j);
				if(String.valueOf(ht4.get("COST_ST")).equals("1")){
					vts3.add(ht4);
					vts3.add(ht2);
				}else{
					vts3.add(ht4);
				}
			}
		}
		vts2 = vts3;
		vt_size2 = vts2.size();
	}
	
	if(gubun3.equals("17") || gubun3.equals("")){
		//����Ʈ
		Vector vts5 = ac_db.getSaleCostCampaignMngListRm(s_kd, t_wd, sort, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, cs_dt, ce_dt);
		int vt_size5 = vts5.size();
		for(int j = 0 ; j < vt_size5 ; j++){
			Hashtable ht5 = (Hashtable)vts5.elementAt(j);
			vts2.add(ht5);
		}
		vt_size2 = vts2.size();
	}
	
	
   	long af_amt[]	 		= new long[2];
	long ea_amt[]	 		= new long[2];
	long bc_s_g[]	 		= new long[2];
	long fee_s_amt[]		= new long[2];
	long trf_amt[]			= new long[2];
	
	long a_amt[]	 		= new long[2];
   	long s_tot[]	 		= new long[2];
	long ac_amt[]	 		= new long[2];
	long g_tot[]	 		= new long[2];
	long ave_amt[]			= new long[2];
	
   	float f_amt8[]			= new float[2];
   	float f_af_amt[]		= new float[2];
   	float f_fee_s_amt[]		= new float[2];
	
   	long amt1[]	 		= new long[2];
	long amt2[]	 		= new long[2];
	long amt3[]	 		= new long[2];
	long amt4[]	 		= new long[2];
	long amt5[]	 		= new long[2];
	long amt6[]	 		= new long[2];
	long amt7[]	 		= new long[2];
	long amt8[]	 		= new long[2];
	long amt9[]	 		= new long[2];
	long amt10[] 			= new long[2];
	long amt11[] 			= new long[2];
	long amt12[] 			= new long[2];
	long amt13[] 			= new long[2];
	long amt14[] 			= new long[2];
	long amt15[] 			= new long[2];
	long amt16[] 			= new long[2];
	long amt17[] 			= new long[2];
	long amt18[] 			= new long[2];
	long amt19[] 			= new long[2];
	long amt20[] 			= new long[2];
	long amt21[] 			= new long[2];
	long amt22[] 			= new long[2];
	long amt23[] 			= new long[2];
	long amt24[] 			= new long[2];
	long amt25[] 			= new long[2];
	long amt26[] 			= new long[2];
	long amt27[] 			= new long[2];
	long amt28[] 			= new long[2];
	long amt29[] 			= new long[2];
	long amt30[] 			= new long[2];
	long amt31[] 			= new long[2];
	long amt32[] 			= new long[2];
	long amt33[] 			= new long[2];
	long amt34[] 			= new long[2];
	long amt35[] 			= new long[2];
	long amt36[] 			= new long[2];
	long amt37[] 			= new long[2];
	long amt39[] 			= new long[2];
	long amt40[] 			= new long[2];
	long amt41[] 			= new long[2];
	long amt43[] 			= new long[2];
	long amt44[] 			= new long[2];
	
   	float ea_per[]			= new float[2];
   	float dc_per[]			= new float[2];
   	float fee_per[]			= new float[2];
	
%>

<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript" src="/include/table_fix.js?ver=0.2"></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css?ver=0.2">
<link rel="stylesheet" type="text/css" href="/include/table_fix.css?ver=0.2">


<script language="JavaScript">
<!--

//�˾������� ����
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}

function cmp_help_cont(){
		var SUBWIN= "view_sale_cost_help.jsp";
		window.open(SUBWIN, "View_Help", "left=50, top=50, width=820, height=700, resizable=yes, scrollbars=yes");
}	
	
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
<input type='hidden' name='height' id="height" value='<%=height%>'>

<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
		<%if(mode.equals("cmp")){%>
		  <tr> 
		        <td colspan=2><a href='javascript:cmp_help_cont()' title='����'><img src=/acar/images/center/button_exp.gif border=0 align=absmiddle></a></td>
		  </tr>
		<%}%>
			<tr>
				<td style="width: 550px;">
					<div style="width: 550px;">
						<table class="inner_top_table left_fix" style="height: 80px;">
						
							  <tr> 
			                    <td width='6%' class='title title_border' rowspan=2>����</td>
			                    <td width='11%' class='title title_border' rowspan=2>����<br>������</td>
			    		 		<td width='11%' class='title title_border' rowspan=2>����<br>�븮��</td>
			                    <td width='19%' class='title title_border' rowspan=2>����ȣ</td>
			    		    	<td width='18%' class='title title_border' rowspan=2>����</td>
			                    <td width='18%' class='title title_border' rowspan=2>����</td>
			                    <td width='17%' class='title title_border' rowspan=2>����<br>��ȣ</td>
			                </tr>        
                
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 80px;">							
							<colgroup>
				       			<col width="130">
				       			<col width="90">
				       			<col width="90">
				       			<col width="110">				       			
				       			<col width="110"> 				       					       		
				       			<col width="80">
				       			<col width="80">
				       			<col width="90">
				       			<col width="80">
				       			<col width="80">
				       			<col width="80">				       			
				       			<col width="110"> 				       					       		
				       			<col width="80">  <!-- ������ -->
				       			<col width="110"> 	
				       			<col width="110">
				       			<col width="80">
				       			<col width="100">
				       			<col width="110">
				       			
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">				       			
				       			<col width="110">		       			
				       			<col width="110">		       			
				       			<col width="110">		       			
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">				       			
				       			<col width="110">		       			
				       			<col width="110">		       			
				       			<col width="110">		       			
				       			<col width="110">
				       			<col width="80">
				       			<col width="110">
				       			<col width="110">				       			
				       			<col width="110">		       			
				       			<col width="110">		       			
				       			<col width="110">		       			
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">				       			
				       			<col width="110">		       			
				       			<col width="110">		       			
				       			<col width="110">		       			
				       			<col width="110">
				       			
				       			<col width="110">		       			
				       			<col width="110">
				       			
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">				       			
				       			<col width="110">		       			
				       			<col width="110">		       			
				       			<col width="110">		       			
				       			<col width="110">
				       			<col width="110">
				       			
				       		</colgroup>
																      
					        <tr>
			                    <td width='130' class='title title_border' rowspan=3>����</td>		 
			                    <td width='90' class='title title_border' rowspan=3>��������</td>
			                    <td width='90' class='title title_border' rowspan=3>�뿩������</td>
			                    <td width='110' class='title title_border' rowspan=3>���뿩��<br>���簡ġ</td>
			                    <td width='110' class='title title_border' rowspan=3>����<br>ȿ��</td>
			                    <td width='80' class='title title_border' rowspan=3>����</td>		 
			                    <td width='80' class='title title_border' rowspan=3>����<br>����</td>
			                    <td width='90' class='title title_border' rowspan=3>���<br>����</td>
			                    <td width='80' class='title title_border' rowspan=3>�뵵<br>����</td>
			                    <td width='80' class='title title_border' rowspan=3>����<br>����</td>
			                    <td width='80' class='title title_border' rowspan=3>���<br>�Ⱓ</td>      
			                    <td width='110' class='title title_border' rowspan=3>�뿩<br>������</td>               		 
			                    <td width='80' class='title title_border' rowspan=3>����<br>���</td>
			                    <td width='110' class='title title_border' rowspan=3>����<br>�뿩��</td>   
			                    <td width='110' class='title title_border' rowspan=3>���<br>�뿩��</td>           
			                    <td width="80" class='title title_border' rowspan=3>������</td>
			                    <td width="100" class='title title_border' rowspan=3>��ü<br>���<br>����</td>
			                    <td width="110" class='title title_border' rowspan=3>ī��<br>�����ݾ�</td>
			             	    <td class="title title_border" colspan=15>����������+��븶��+��Ÿ����</td>
			             	    <td class="title title_border" colspan=15>����׸�</td>
			                    <td class="title title_border" colspan=9>��Ÿ����ȿ���ݿ���</td>                               
			                </tr>
			                <tr>
			              	    <td width=110 class="title title_border" rowspan=2>�⺻��<br>������</td>
			                    <td width=110 class="title title_border" rowspan=2>�Ϲݽ�<br>�߰�������</td>
			                    <td width=110 class="title title_border" rowspan=2>��븶��</td>
			    		  		<td width=110 class="title title_border" rowspan=2>���Ǻ���<br>���Ժ�</td>
			                    <td width=110 class="title title_border" rowspan=2>�縮��<br>�ʱ�<br>�������</td>
			                    <td width=110 class="title title_border" rowspan=2>�縮��<br>�߰���<br>������</td>
			                    <td width=110 class="title title_border" rowspan=2>ī�����<br>ĳ����</td>
			                    <td width=110 class="title title_border" rowspan=2>ī�����ĳ����<br>�����ݿ���</td>
			                    <td width=110 class="title title_border" rowspan=2>���������</td>
			                    <td width=110 class="title title_border" rowspan=2>���������<br>�����ݿ���</td>
			                    <td width=110 class="title title_border" rowspan=2>�����̰�<br>�������</td>
			                    <td width=110 class="title title_border" rowspan=2>������Ʈ<br>�����������</td>
			                    <td width=110 class="title title_border" rowspan=2>��Ÿ</td>   
			                    <td width=110 class="title title_border" rowspan=2>�հ�</td> 
			                    <td width=80  class="title title_border" rowspan=2>���<br>�뿩��<br>���</td> 			                
			                    <td width=110 class="title title_border" rowspan=2>�⺻��<br>�ּ�<br>�������</td> 
			                    <td width=110 class="title title_border" rowspan=2>�Ϲݽ�<br>�ּ�<br>�������</td>  
			                    <td width=110 class="title title_border" rowspan=2>�縮������<br>������<br>(����)</td>
			                    <td width=110 class="title title_border" rowspan=2>����<br>�縮������<br>������</td>  
			                    <td width=110 class="title title_border" rowspan=2>����Ŀ�߰�<br>Ź�ۺ��</td> 
			                    <td width=110 class="title title_border" rowspan=2>���ú��</td> 
			                    <td width=110 class="title title_border" rowspan=2>���޿�ǰ</td>  
			                    <td width=110 class="title title_border" rowspan=2>�����̹ݿ�<br>����ǰ��</td> 
			                    <td width=110 class="title title_border" rowspan=2>�����ε�<br>Ź�ۺ��</td>  			
			                    <td width=110 class="title title_border" rowspan=2>�����ε�<br>������</td>  
			                    <td width=110 class="title title_border" rowspan=2>��Ʈ<br>����⵿<br>���谡�Ժ�</td> 			
			                    <td width=110 class="title title_border" rowspan=2>��Ÿ<br>���</td> 
			                    <td width=110 class="title title_border" rowspan=2>ī�����������<br>������</td> 
			                    <td class="title title_border" colspan=2>����հ�</td>                  
			                    <td width=110 class="title title_border" rowspan=2>����Ŀ<br>����D/C<br>(����)</td>  
			                    <td width=110 class="title title_border" rowspan=2>����Ŀ<br>�߰�D/C<br>(�ݿ���)</td> 
			                    <td width=110 class="title title_border" rowspan=2>�ܰ�����ũ<br>����ȿ��</td>  
			                    <td width=110 class="title title_border" rowspan=2>�������<br>����ݸ���<br>(����)</td> 
			                    <td width=110 class="title title_border" rowspan=2>������<br>����ݸ���</td>  
			                    <td width=110 class="title title_border" rowspan=2>���°�<br>������</td>  
			                    <td width=110 class="title title_border" rowspan=2>���������</td>  
			                    <td width=110 class="title title_border" rowspan=2>��Ÿ</td>  						
			                    <td width=110 class="title title_border" rowspan=2>�հ�</td>               
			                </tr>
			                <tr>
			                    <td width=110 class="title title_border" >�Ǻ��</td>  
			                    <td width=110 class="title title_border" >��ġ</td>   
			                </tr>              
                
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="tb_box">
		<table class="tb">
			<tr>
				<td style="width: 550px;">
					<div style="width: 550px;">
						<table class="inner_top_table left_fix">  					
	
			<%	if(vt_size2 > 0){%>  
			                <%for(int i = 0 ; i < vt_size2 ; i++){
						Hashtable ht = (Hashtable)vts2.elementAt(i);%>
			                <tr>
			          	 	    <td class="center content_border" width='6%'><%= i+1%></td> 
			                    <td class="center content_border" width='11%'><%=ht.get("USER_NM")%></td>
			                    <td class="center content_border" width='11%'><%=ht.get("BUS_AGNT_NM")%></td>			 
			                    <td class="center content_border" width='19%'>
						 <%if(mode.equals("cmp") || String.valueOf(ht.get("CMP_ST_NM")).equals("����Ʈ")){%>
						     <%=ht.get("RENT_L_CD")%>
						 <%}else{%>
							 <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�ӿ�",user_id) || nm_db.getWorkAuthUser("������������",user_id)){%>	
						     <a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("RENT_ST")%>')" onMouseOver="window.status=''; return true" title='��೻��'><%=ht.get("RENT_L_CD")%></a>
						     <%}else{ %>
						     <%=ht.get("RENT_L_CD")%>
						     <%} %>
						 <%}%>			 
			                    </td>
			                    <td class="center content_border" width='18%'><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span></td>
			                    <td class="center content_border" width='18%'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 6)%></span></td>
			                    <td class="center content_border" width='17%'><span title='<%=ht.get("CAR_NO")%>'><%=ht.get("CAR_NO")%></span></td>
			                </tr>
			  	<%		} %>
			                <tr> 
						        <td colspan="7" class="title  content_border center">&nbsp;�հ�</td>
					        </tr>
			<%} else  {%>  
				           	<tr>
						        <td class='center content_border'>��ϵ� ����Ÿ�� �����ϴ�</td>
						    </tr>	              
		     <%}	%>	   
			            </table>
			         </div>            
				  </td>              
		       		         
				  <td>			
		     	 	<div>
						<table class="inner_top_table table_layout">    
						   
	 		<%	if(vt_size2 > 0){%>   		
                <%for(int i = 0 ; i < vt_size2 ; i++){
						Hashtable ht = (Hashtable)vts2.elementAt(i);
								
						af_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AF_AMT")));
						bc_s_g[0] 		= AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")));
						fee_s_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT")));
						trf_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("TRF_AMT")));
						f_af_amt[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT")));
						f_fee_s_amt[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("FEE_S_AMT")));
						f_amt8[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AMT8")));
						ea_per[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("EA_PER")));
						dc_per[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("DC_PER")));
						fee_per[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("FEE_PER")));
								
						amt1[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT1")));
						amt2[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
						amt3[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
						amt4[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT4")));
						amt5[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT5")));
						amt6[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT6")));
						amt7[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT7")));
						amt8[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT8")));
						amt9[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT9")));
						amt10[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT10")));
						amt11[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT11")));
						amt12[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT12")));
						amt13[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT13")));
						amt14[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT14")));
						amt15[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT15")));
						amt16[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT16")));
						amt17[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT17")));
						amt18[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT18")));
						amt19[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT19")));
						amt20[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT20")));
						amt21[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT21")));
						amt22[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT22")));
						amt23[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT23")));
						amt24[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT24")));
						amt25[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT25")));
						amt26[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT26")));
						amt27[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT27")));
						amt28[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT28")));
						amt29[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT29")));
						amt30[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT30")));
						amt31[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT31")));
						amt32[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT32")));
						amt33[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT33")));
						amt34[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT34")));
						amt35[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT35")));
						amt36[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT36")));
						amt37[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT37")));
						amt39[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT39")));
						amt40[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT40")));
						amt41[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT41")));
						amt43[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT43")));
						amt44[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT44")));
						
						if(AddUtil.parseInt(String.valueOf(ht.get("CMP_DT"))) >= 20151101){
							ea_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("EA_AMT")));					
						}else{
							ea_amt[0] 		= amt8[0]-amt21[0]+amt30[0];
						}			
						
											
						if(!String.valueOf(ht.get("COST_ST")).equals("6")){
							if(gubun3.equals("4") || gubun3.equals("9")){
								if(String.valueOf(ht.get("COST_ST")).equals("7")){
									af_amt[1] 		+= af_amt[0];
									bc_s_g[1] 		+= bc_s_g[0];
									fee_s_amt[1] 		+= fee_s_amt[0];
									trf_amt[1] 		+= trf_amt[0];
									f_af_amt[1] 		+= f_af_amt[0];
									f_fee_s_amt[1] 		+= f_fee_s_amt[0];
									f_amt8[1] 		+= f_amt8[0];
									
									ea_per[1] 		+= ea_per[0];
									dc_per[1] 		+= dc_per[0];
									fee_per[1] 		+= fee_per[0];
									
									ea_amt[1] 		+= ea_amt[0];
								
									amt1[1] 		+= amt1[0];
									amt2[1] 		+= amt2[0];
									amt3[1] 		+= amt3[0];
									amt4[1] 		+= amt4[0];
									amt5[1] 		+= amt5[0];
									amt6[1] 		+= amt6[0];
									amt7[1] 		+= amt7[0];
									amt8[1] 		+= amt8[0];
									amt9[1] 		+= amt9[0];
									amt10[1] 		+= amt10[0];
									amt11[1] 		+= amt11[0];
									amt12[1] 		+= amt12[0];
									amt13[1] 		+= amt13[0];
									amt14[1] 		+= amt14[0];
									amt15[1] 		+= amt15[0];
									amt16[1] 		+= amt16[0];
									amt17[1] 		+= amt17[0];
									amt18[1] 		+= amt18[0];
									amt19[1] 		+= amt19[0];
									amt20[1] 		+= amt20[0];
									amt21[1] 		+= amt21[0];
									amt22[1] 		+= amt22[0];
									amt23[1] 		+= amt23[0];
									amt24[1] 		+= amt24[0];
									amt25[1] 		+= amt25[0];
									amt26[1] 		+= amt26[0];
									amt27[1] 		+= amt27[0];
									amt28[1] 		+= amt28[0];
									amt29[1] 		+= amt29[0];
									amt30[1] 		+= amt30[0];
									amt31[1] 		+= amt31[0];
									amt32[1] 		+= amt32[0];
									amt33[1] 		+= amt33[0];
									amt34[1] 		+= amt34[0];
									amt35[1] 		+= amt35[0];
									amt36[1] 		+= amt36[0];
									amt37[1] 		+= amt37[0];
									amt39[1] 		+= amt39[0];
									amt40[1] 		+= amt40[0];
									amt41[1] 		+= amt41[0];
									amt43[1] 		+= amt43[0];
									amt44[1] 		+= amt44[0];
								}
							}else{
									af_amt[1] 		+= af_amt[0];
									bc_s_g[1] 		+= bc_s_g[0];
									fee_s_amt[1] 		+= fee_s_amt[0];
									trf_amt[1] 		+= trf_amt[0];
									f_af_amt[1] 		+= f_af_amt[0];
									f_fee_s_amt[1] 		+= f_fee_s_amt[0];
									f_amt8[1] 		+= f_amt8[0];
									
									ea_per[1] 		+= ea_per[0];
									dc_per[1] 		+= dc_per[0];
									fee_per[1] 		+= fee_per[0];
									
									ea_amt[1] 		+= ea_amt[0];
											
									amt1[1] 		+= amt1[0];
									amt2[1] 		+= amt2[0];
									amt3[1] 		+= amt3[0];
									amt4[1] 		+= amt4[0];
									amt5[1] 		+= amt5[0];
									amt6[1] 		+= amt6[0];
									amt7[1] 		+= amt7[0];
									amt8[1] 		+= amt8[0];
									amt9[1] 		+= amt9[0];
									amt10[1] 		+= amt10[0];
									amt11[1] 		+= amt11[0];
									amt12[1] 		+= amt12[0];
									amt13[1] 		+= amt13[0];
									amt14[1] 		+= amt14[0];
									amt15[1] 		+= amt15[0];
									amt16[1] 		+= amt16[0];
									amt17[1] 		+= amt17[0];
									amt18[1] 		+= amt18[0];
									amt19[1] 		+= amt19[0];
									amt20[1] 		+= amt20[0];
									amt21[1] 		+= amt21[0];
									amt22[1] 		+= amt22[0];
									amt23[1] 		+= amt23[0];
									amt24[1] 		+= amt24[0];
									amt25[1] 		+= amt25[0];
									amt26[1] 		+= amt26[0];
									amt27[1] 		+= amt27[0];
									amt28[1] 		+= amt28[0];
									amt29[1] 		+= amt29[0];
									amt30[1] 		+= amt30[0];
									amt31[1] 		+= amt31[0];
									amt32[1] 		+= amt32[0];
									amt33[1] 		+= amt33[0];
									amt34[1] 		+= amt34[0];
									amt35[1] 		+= amt35[0];
									amt36[1] 		+= amt36[0];
									amt37[1] 		+= amt37[0];
									amt39[1] 		+= amt39[0];
									amt40[1] 		+= amt40[0];
									amt41[1] 		+= amt41[0];
									amt43[1] 		+= amt43[0];
									amt44[1] 		+= amt44[0];
							}
						}			
					%>                
		                <tr> 
		                    <td class="center content_border" width='130' style="font-size : 8pt;"><%=ht.get("CMP_ST_NM")%>&nbsp;</td>
		                    <td class="center content_border" width='90'><%=ht.get("CMP_DT")%>&nbsp;</td>
		                    <td class="center content_border" width='90'><%=ht.get("RENT_START_DT")%>&nbsp;</td>
			  	 		    <td width="110" class="right content_border"><%=Util.parseDecimal(af_amt[0])%>&nbsp;</td>  <!--���뿩�����簡ġ -->
			  			    <td width="110" class="right content_border"><%=Util.parseDecimal(ea_amt[0])%>&nbsp;</td>  <!--����ȿ�� -->
			  			    <td width="80" class="right content_border">
				        <% if (  af_amt[0] == 0 ) { %> 0
		                        <% } else { %> 
		                            <%if(AddUtil.parseInt(String.valueOf(ht.get("CMP_DT"))) >= 20151101){%>
		                                <%=ht.get("EA_PER")%>
		                            <%}else{%>
		                                <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[0]/f_af_amt[0]*100),2)%>
		                            <%}%>
		                        <% } %>&nbsp;
			  	   			</td>  <!--���� -->			
		                    <td class="center content_border" width='80'><%=ht.get("CAR_GU_NM")%>&nbsp;</td>
		                    <td class="center content_border" width='90'><%=ht.get("RENT_ST_NM")%>&nbsp;</td>
		                    <td class="center content_border" width='80'><%=ht.get("CAR_ST_NM")%>&nbsp;</td>
		                    <td class="center content_border" width='80'><%=ht.get("RENT_WAY_NM")%>&nbsp;</td>
		                    <td class="center content_border" width='80'><%=ht.get("CON_MON")%>&nbsp;</td>
		                    <td class="center content_border" width='110'><%=ht.get("RENT_START_DT")%>&nbsp;</td>		  
					  	    <td class="center content_border" width='80'><%=ht.get("SPR_KD_NM")%>&nbsp;</td>
					  	    <td width="110" class="right content_border"><%=Util.parseDecimal(bc_s_g[0])%>&nbsp;</td>  <!--����뿩�� -->
					  	    <td width="110" class="right content_border"><%=Util.parseDecimal(fee_s_amt[0])%>&nbsp;</td>  <!--���뿩�� -->						
					  	    <td width="80" class="right content_border">
						        <% if (  bc_s_g[0] == 0 ) { %> 0
							<% } else { %> 
							    <%if(AddUtil.parseInt(String.valueOf(ht.get("CMP_DT"))) >= 20151101){%>
				                                <%=ht.get("DC_PER")%>
				                            <%}else{%>
							        <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[0]-f_fee_s_amt[0])/bc_s_g[0] ) * 100),2)%>
							    <%}%>    
							<% } %>&nbsp;	  	    
					  	    </td>  <!--������ -->
					  	    <td width="100" class="right content_border"><%=ht.get("COMMI2_NM")%>&nbsp;</td>
					  	    <td width="110" class="right content_border"><%=Util.parseDecimal(trf_amt[0])%>&nbsp;</td>  <!--ī�����ݾ�-->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt1[0])%>&nbsp;</td>  <!--�⺻�İ�����-->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt2[0])%>&nbsp;</td>  <!--�Ϲݽİ�����-->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt3[0])%>&nbsp;</td>  <!--��븶��-->
				   			<td width="110" class="right content_border"><%=Util.parseDecimal(amt34[0])%>&nbsp;</td>  <!--���Ǻ��谡�Ժ�-->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt4[0])%>&nbsp;</td>  <!--�縮���ʱ⿵�����-->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt5[0])%>&nbsp;</td>  <!--�縮���߰���������-->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt6[0])%>&nbsp;</td>  <!-- ī�����ĳ����-->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt40[0])%>&nbsp;</td>  <!-- ī�����ĳ��������ݿ���-->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt35[0])%>&nbsp;</td>  <!-- ���������-->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt41[0])%>&nbsp;</td>  <!-- �������������ݿ���-->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt36[0])%>&nbsp;</td>  <!-- �����̰��������-->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt39[0])%>&nbsp;</td>  <!-- ������Ʈ�����������-->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt7[0])%>&nbsp;</td>  <!--��Ÿ-->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt8[0])%>&nbsp;</td>  <!--�հ� -->
					  	    <td width="80" class="right content_border">
							<% if (  f_af_amt[0] == 0 ) { %> 0
				                        <% } else { %> 
				                            <%if(AddUtil.parseInt(String.valueOf(ht.get("CMP_DT"))) >= 20151101){%>
				                                <%=ht.get("FEE_PER")%>
				                            <%}else{%>
				                                <%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[0]/f_af_amt[0]*100),2)%>
				                            <%}%>    
				                        <% } %>&nbsp;	  	    
					  	    </td>  <!--���뿩���� -->									                        
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt9[0])%>&nbsp;</td> <!--�⺻���ּҰ������ -->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt10[0])%>&nbsp;</td> <!--�Ϲݽ��ּҰ������ --> 
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt11[0])%>&nbsp;</td> <!--�縮������������ -->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt12[0])%>&nbsp;</td> <!--�����縮�������� -->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt13[0])%>&nbsp;</td> <!--����Ŀ�߰�Ź�� -->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt15[0])%>&nbsp;</td> <!--���ú�� -->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt16[0])%>&nbsp;</td> <!--���޿�ǰ -->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt17[0])%>&nbsp;</td> <!--�����̹ݿ�����ǰ�� -->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt14[0])%>&nbsp;</td> <!--�����ε�Ź�ۺ��  -->			
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt18[0])%>&nbsp;</td> <!--�����ε������� -->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt33[0])%>&nbsp;</td> <!--��Ʈ����⵿���谡�Ժ�->�ӽÿ��ຸ���-->			
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt19[0])%>&nbsp;</td> <!--��Ÿ��� -->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt37[0])%>&nbsp;</td> <!--ī����������������� -->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt20[0])%>&nbsp;</td> <!--�Ǻ�� -->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt21[0])%>&nbsp;</td> <!--��ġ -->        
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt22[0])%>&nbsp;</td> <!--����D/C -->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt23[0])%>&nbsp;</td> <!--�߰�D/C -->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt24[0])%>&nbsp;</td> <!--�ܰ�����ũ����ȿ�� -->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt25[0])%>&nbsp;</td> <!--�����������ݸ���  -->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt26[0])%>&nbsp;</td> <!--����������ݸ��� -->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt27[0])%>&nbsp;</td> <!--�°������ -->
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt28[0])%>&nbsp;</td> <!--�����    --> 	
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt29[0])%>&nbsp;</td> <!--��Ÿ  -->                   
		                    <td width="110" class="right content_border"><%=Util.parseDecimal(amt30[0])%>&nbsp;</td> <!--�հ� -->            
		                </tr>
		             <%}%>    
		                <tr> 
		                    <td class='title content_border' style='text-align:center;'>&nbsp;</td>		   
		                    <td class='title content_border' style='text-align:center;'>&nbsp;</td>		   			 
		                    <td class='title content_border' style='text-align:center;'>&nbsp;</td>		   			 
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(af_amt[1])%>&nbsp;</td>		  
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(ea_amt[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'>
				        <% if (  af_amt[1] == 0 ) { %> 0
		                        <% } else { %> 
		                        <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[1]/f_af_amt[1]*100),2)%>
		                        <% } %>&nbsp;
		                    </td>		  
		                    <td class='title content_border' style='text-align:center;'>&nbsp;</td>
		                    <td class='title content_border' style='text-align:center;'>&nbsp;</td>
		                    <td class='title content_border' style='text-align:center;'>&nbsp;</td>
		                    <td class='title content_border' style='text-align:center;'>&nbsp;</td>
		                    <td class='title content_border' style='text-align:center;'>&nbsp;</td>
		                    <td class='title content_border' style='text-align:center;'>&nbsp;</td>
		                    <td class='title content_border' style='text-align:center;'>&nbsp;</td>			 			 			 			 			 			 
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(bc_s_g[1])%>&nbsp;</td>		  
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(fee_s_amt[1])%>&nbsp;</td>		  
		                    <td class='title content_border' style='text-align:right;'>
				        <% if (  bc_s_g[1] == 0 ) { %> 0
					<% } else { %> 
					    <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[1]-f_fee_s_amt[1])/(bc_s_g[1]-amt43[1]-amt44[1]) ) * 100),2)%>
					<% } %>&nbsp;
				  		    </td>		  												
		                    <td class='title content_border' style='text-align:right;'>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(trf_amt[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt1[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt2[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt3[1])%>&nbsp;</td>
				   		    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt34[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt4[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt5[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt6[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt40[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt35[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt41[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt36[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt39[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt7[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt8[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'>
				        <% if (  af_amt[1] == 0 ) { %> 0
		                        <% } else { %> 
					    <%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[1]/f_af_amt[1]*100),2)%>
		                        <% } %>&nbsp;
		                    </td>		  			
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt9[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt10[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt11[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt12[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt13[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt15[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt16[1])%>&nbsp;</td>                       
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt17[1])%>&nbsp;</td>  
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt14[1])%>&nbsp;</td>			
		    		        <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt18[1])%>&nbsp;</td> 
		    		    	<td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt33[1])%>&nbsp;</td> 			
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt19[1])%>&nbsp;</td> 
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt37[1])%>&nbsp;</td> 
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt20[1])%>&nbsp;</td> 
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt21[1])%>&nbsp;</td>             
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt22[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt23[1])%>&nbsp;</td>  
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt24[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt25[1])%>&nbsp;</td> 
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt26[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt27[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt28[1])%>&nbsp;</td> 
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt29[1])%>&nbsp;</td>
		                    <td class='title content_border' style='text-align:right;'><%= Util.parseDecimal(amt30[1])%>&nbsp;</td>          
		         		</tr>	  
		   	<%} else  {%>  
				       	<tr>
						    <td class='center content_border' colspan=57>��ϵ� ����Ÿ�� �����ϴ�</td>
					    </tr>	              
				     <%}	%>			
				     
					 	  </table>
			   	    </div>
			    </td>
			</tr>
		</table>
	</div>
</div>		    
</form>
</body>
</html>
