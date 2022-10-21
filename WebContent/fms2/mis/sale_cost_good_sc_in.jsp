<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="cmp_db" scope="page" class="acar.stat_bus.CampaignDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
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
   	
	
	//����/�縮��/����
	Vector vts1 = ac_db.getSaleCostCampaignGoodStatList(s_kd, t_wd, sort, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, cs_dt, ce_dt);
	int vt_size1 = vts1.size(); 
	
	//��Ÿȿ��(�縮��/��������)
	Vector vts2 = new Vector();
	int vt_size2 = vts2.size();
	
	//��Ÿȿ��(�߰��̿�,���°�,�����)
	Vector vts3 = ac_db.getSaleCostCampaignGoodEtcStatList(s_kd, t_wd, sort, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, cs_dt, ce_dt);
	int vt_size3 = vts3.size();
	
	//��Ÿȿ��(����Ʈ)
	Vector vts4 = ac_db.getSaleCostCampaignGoodEtcStatListRm(s_kd, t_wd, sort, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, cs_dt, ce_dt);
	int vt_size4 = vts4.size();
	
	if(vt_size4>0){
		for(int j = 0 ; j < vt_size4 ; j++){
			Hashtable ht4 = (Hashtable)vts4.elementAt(j);
			vts3.add(ht4);
		}
		vt_size3 = vts3.size();
	}


	int car_type_cnt = 0;
	int car_type_size1 = 0;
	int car_type_size2 = 0;
	int car_type_size3 = 0;
	int car_type_size4 = vt_size2+vt_size3;
	
	for(int i = 0 ; i < vt_size1 ; i++){
		Hashtable ht = (Hashtable)vts1.elementAt(i);
		if(String.valueOf(ht.get("CAR_TYPE")).equals("1")) car_type_size1++;
		if(String.valueOf(ht.get("CAR_TYPE")).equals("2")) car_type_size2++;
		if(String.valueOf(ht.get("CAR_TYPE")).equals("3")) car_type_size3++;
	}
	
   	long rent_way_2_cnt[]	= new long[7];//�⺻�Ŀ������
	long rent_way_1_cnt[]	= new long[7];//�ϹݽĿ������
	long rent_way_t_cnt[]	= new long[7];//��������Ұ�
	
   	long af_amt[]	 		= new long[7];
	long af_amt2[]	 		= new long[7];
	long ea_amt[]	 		= new long[7];
	long bc_s_g[]	 		= new long[7];
	long fee_s_amt[]		= new long[7];
	long point_dc_amt[]		= new long[7];
	
	long a_amt[]	 		= new long[7];
   	long s_tot[]	 		= new long[7];
	long ac_amt[]	 		= new long[7];
	long g_tot[]	 		= new long[7];
	long ave_amt[]			= new long[7];
	
   	float f_amt8[]			= new float[7];
   	float f_af_amt[]		= new float[7];
	float f_af_amt2[]		= new float[7];
   	float f_fee_s_amt[]		= new float[7];
   	float f_point_dc_amt[]		= new float[7];
	
   	long amt1[]	 		= new long[7];
	long amt2[]	 		= new long[7];
	long amt3[]	 		= new long[7];
	long amt4[]	 		= new long[7];
	long amt5[]	 		= new long[7];
	long amt6[]	 		= new long[7];
	long amt7[]	 		= new long[7];
	long amt8[]	 		= new long[7];
	long amt9[]	 		= new long[7];
	long amt10[] 			= new long[7];
	long amt11[] 			= new long[7];
	long amt12[] 			= new long[7];
	long amt13[] 			= new long[7];
	long amt14[] 			= new long[7];
	long amt15[] 			= new long[7];
	long amt16[] 			= new long[7];
	long amt17[] 			= new long[7];
	long amt18[] 			= new long[7];
	long amt19[] 			= new long[7];
	long amt20[] 			= new long[7];
	long amt21[] 			= new long[7];
	long amt22[] 			= new long[7];
	long amt23[] 			= new long[7];
	long amt24[] 			= new long[7];
	long amt25[] 			= new long[7];
	long amt26[] 			= new long[7];
	long amt27[] 			= new long[7];
	long amt28[] 			= new long[7];
	long amt29[] 			= new long[7];
	long amt30[] 			= new long[7];
	long amt31[] 			= new long[7];
	long amt32[] 			= new long[7];
	long amt33[] 			= new long[7];
	long amt34[] 			= new long[7];
	long amt35[] 			= new long[7];
	long amt36[] 			= new long[7];
	long amt37[] 			= new long[7];
	long amt39[] 			= new long[7];
	long amt40[] 			= new long[7];
	long amt41[] 			= new long[7];
	
	long amt43[] 			= new long[7];
	long amt44[] 			= new long[7];
	long amt45[] 			= new long[7];
	long amt46[] 			= new long[7];
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	/* Title ���� */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}

	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form action="" name="form1" method="POST">

<table border="0" cellspacing="0" cellpadding="0" width="5970">
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>  
	<td class='line' width='400' id='td_title' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height=90>
                <tr> 
                    <td class='title' colspan=6 >����</td>
                </tr>
                <tr> 
                    <td width='30' class='title' rowspan=2>����</td>
                    <td width='160' class='title' rowspan=2>����</td>
                    <td class='title' colspan=3 >���</td>
                </tr>
                <tr> 
                    <td  width="70" class='title' >�������</td>
                    <td  width="70" class='title' >�߻��Ǽ�</td>
                    <td  width="70" class='title' >�Ѱ�����</td>
                </tr>        
            </table>
        </td>
	<td class='line' width='5570'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height=90>
                <tr>
	            <td width='110' class='title' rowspan=3>����<br>(�׸鰡)</td>		  
                    <td width='110' class='title' rowspan=3>���뿩��<br>���簡ġ</td>		  
                    <td width='110' class='title' rowspan=3>����ȿ��</td>
                    <td width='80' class='title' rowspan=3>����</td>		 
                    <td width='100' class='title' rowspan=3>���<br>����ȿ��</td>
                    <td width='100' class='title' rowspan=3>������<br>����ȿ��</td>			
                    <td width='110' class='title' rowspan=3>����뿩��</td>
                    <td width='110' class='title' rowspan=3>���뿩��</td>		
                    <td width='80' class='title' rowspan=3>������</td>		 				
         	    <td class="title" colspan=18>����������+��븶��+��Ÿ����</td>
           	    <td class="title" colspan=16>����׸�</td>
                    <td class="title" colspan=9>��Ÿ����ȿ���ݿ���</td>
                </tr>          
                <tr>
         	    <td width=110 class="title" rowspan=2>�⺻��<br>������</td>
                    <td width=110 class="title" rowspan=2>�Ϲݽ�<br>������</td>
                    <td width=110 class="title" rowspan=2>��븶��</td>
		    <td width=110 class="title" rowspan=2>���Ǻ���<br>���Ժ�</td>
                    <td width=110 class="title" rowspan=2>�縮��<br>�ʱ⿵�����</td>
                    <td width=110 class="title" rowspan=2>�縮��<br>�߰���<br>������</td>
                    <td width=110 class="title" rowspan=2>ī�����<br>ĳ����</td>
                    <td width=110 class="title" rowspan=2>ī�����ĳ����<br>�����ݿ���</td>
                    <td width=110 class="title" rowspan=2>���������</td>
                    <td width=110 class="title" rowspan=2>���������<br>�����ݿ���</td>
                    <td width=110 class="title" rowspan=2>�����̰�<br>�������</td>
                    <td width=110 class="title" rowspan=2>������Ʈ<br>�����������</td>
                    <td width=100 class="title" rowspan=2>����Ʈ<br>����ݾ�<br>(����)</td>
                    <td width=100 class="title" rowspan=2>����Ʈ<br>����ݾ�<br>(���밪)</td>
                    <td width=100 class="title" rowspan=2>�縮��������<br>�̵�Ź�۷�<br>�����ݿ���</td>
                    <td width=110 class="title" rowspan=2>��Ÿ</td>   
                    <td width=110 class="title" rowspan=2>�Ұ�</td> 
                    <td width=80 class="title" rowspan=2>���<br>�뿩��<br>���</td>			            
                    <td width=110 class="title" rowspan=2>�⺻��<br>�ּ�<br>�������</td> 
                    <td width=110 class="title" rowspan=2>�Ϲݽ�<br>�ּ�<br>�������</td>  
                    <td width=110 class="title" rowspan=2>�縮������<br>������<br>(����)</td> 
                    <td width=110 class="title" rowspan=2>����<br>�縮������<br>������</td>  
                    <td width=110 class="title" rowspan=2>����Ŀ�߰�<br>Ź�ۺ��</td>
                    <td width=110 class="title" rowspan=2>���ú��</td> 
                    <td width=110 class="title" rowspan=2>���޿�ǰ</td>  
                    <td width=110 class="title" rowspan=2>�����̹ݿ�<br>����ǰ��</td> 
                    <td width=110 class="title" rowspan=2>�����ε�<br>Ź�ۺ��</td>  			
                    <td width=110 class="title" rowspan=2>�����ε�<br>������</td>  
                    <td width=110 class="title" rowspan=2>��Ʈ<br>����⵿<br>���谡�Ժ�</td>  
                    <td width=100 class="title" rowspan=2>�縮��������<br>�̵�Ź�۷�<br>�����ݿ���</td>			
                    <td width=110 class="title" rowspan=2>��Ÿ<br>���</td> 
                    <td width=110 class="title" rowspan=2>ī�����<br>������������</td> 
                    <td class="title" colspan=2>���Ұ�</td>              
                    <td width=110 class="title" rowspan=2>����Ŀ<br>����D/C<br>(����)</td>  
                    <td width=110 class="title" rowspan=2>����Ŀ<br>�߰�D/C<br>(�ݿ���)</td> 
                    <td width=110 class="title" rowspan=2>�ܰ�����ũ<br>����ȿ��</td>  
                    <td width=110 class="title" rowspan=2>�������<br>����ݸ���<br>(����)</td>
                    <td width=110 class="title" rowspan=2>������<br>����ݸ���</td>  
                    <td width=110 class="title" rowspan=2>���°�<br>������</td>
                    <td width=110 class="title" rowspan=2>���������</td>
                    <td width=110 class="title" rowspan=2>��Ÿ</td>  
                    <td width=110 class="title" rowspan=2>�Ұ�</td>               
                </tr> 
                <tr>
                    <td width=110 class="title" >�Ǻ��</td>  
                    <td width=110 class="title" >��ġ</td>   
                </tr>
            </table>
	</td>
    </tr>	  
    <%if(vt_size1 > 0){%>
    <tr height=100>
	<td class='line' width='400' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' >
                <%		car_type_cnt = 0;
				for(int i = 0 ; i < vt_size1 ; i++){
					Hashtable ht = (Hashtable)vts1.elementAt(i);
					if(String.valueOf(ht.get("CAR_TYPE")).equals("1")){ //����
						rent_way_1_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));
						rent_way_2_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT")));
						rent_way_t_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("CON_MON")));
						
						rent_way_1_cnt[2] += rent_way_1_cnt[0];
						rent_way_2_cnt[2] += rent_way_2_cnt[0];
						rent_way_t_cnt[2] += rent_way_t_cnt[0];
						
						rent_way_1_cnt[1] += rent_way_1_cnt[0];
						rent_way_2_cnt[1] += rent_way_2_cnt[0];
						rent_way_t_cnt[1] += rent_way_t_cnt[0];
						
						gubun3 = "1";
						gubun4 = "";
						gubun5 = "";
						gubun6 = "";
						String d_nm = "";
						if(String.valueOf(ht.get("GOOD")).equals("11")){		d_nm = "��Ʈ �Ϲݽ�";	gubun4 = "1";	gubun5 = "1";
						}else if(String.valueOf(ht.get("GOOD")).equals("12")){		d_nm = "��Ʈ �⺻��";	gubun4 = "1";	gubun5 = "2";
						}else if(String.valueOf(ht.get("GOOD")).equals("21")){		d_nm = "���� �Ϲݽ�";	gubun4 = "2";	gubun5 = "1";
						}else if(String.valueOf(ht.get("GOOD")).equals("22")){		d_nm = "���� �⺻��";	gubun4 = "2";	gubun5 = "2";
						}
		%>
                <tr> 
          	    <td align="center" width='30'><%= i+1%></td>
		    <%if(car_type_cnt==0){%>
                    <td align="center" width='60' rowspan='<%=car_type_size1%>'><a href="javascript:parent.list_move('<%=gubun3%>','<%//=gubun4%>','<%//=gubun5%>','<%=gubun6%>');">����</a></td>
	     	    <%}%>
             	    <td align="center" width='100'><a href="javascript:parent.list_move('<%=gubun3%>','<%=gubun4%>','<%=gubun5%>','<%=gubun6%>');"><%=d_nm%></a></td>
             	    <td align="right" width='70'><%=rent_way_1_cnt[0]%>&nbsp;</td>
             	    <td align="right" width='70'><%=rent_way_2_cnt[0]%>&nbsp;</td>
             	    <td align="right" width='70'><%=rent_way_t_cnt[0]%>&nbsp;</td>
          	</tr>
                <%				car_type_cnt++;}}%>		  
          	<tr> 
            	    <td class=title style='text-align:center;' colspan=3>�Ұ�</td>
            	    <td class=title style='text-align:right;'><%=rent_way_1_cnt[2]%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%=rent_way_2_cnt[2]%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%=rent_way_t_cnt[2]%>&nbsp;</td>
          	</tr>				    
                <%		car_type_cnt = 0;
				for(int i = 0 ; i < vt_size1 ; i++){
					Hashtable ht = (Hashtable)vts1.elementAt(i);
					if(String.valueOf(ht.get("CAR_TYPE")).equals("2")){
						rent_way_1_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));
						rent_way_2_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT")));
						rent_way_t_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("CON_MON")));
						
						rent_way_1_cnt[3] += rent_way_1_cnt[0];
						rent_way_2_cnt[3] += rent_way_2_cnt[0];
						rent_way_t_cnt[3] += rent_way_t_cnt[0];
						
						rent_way_1_cnt[1] += rent_way_1_cnt[0];
						rent_way_2_cnt[1] += rent_way_2_cnt[0];
						rent_way_t_cnt[1] += rent_way_t_cnt[0];
						
						gubun3 = "2";
						gubun4 = "";
						gubun5 = "";
						gubun6 = "";
						String d_nm = "";
						if(String.valueOf(ht.get("GOOD")).equals("11")){		d_nm = "��Ʈ �Ϲݽ�";	gubun4 = "1";	gubun5 = "1";
						}else if(String.valueOf(ht.get("GOOD")).equals("12")){		d_nm = "��Ʈ �⺻��";	gubun4 = "1";	gubun5 = "2";
						}else if(String.valueOf(ht.get("GOOD")).equals("21")){		d_nm = "���� �Ϲݽ�";	gubun4 = "2";	gubun5 = "1";
						}else if(String.valueOf(ht.get("GOOD")).equals("22")){		d_nm = "���� �⺻��";	gubun4 = "2";	gubun5 = "2";
						}
		%>
          	<tr> 
          	    <td align="center" width='30'><%= i+1%></td>
		    <%if(car_type_cnt==0){%>
                    <td align="center" width='60' rowspan='<%=car_type_size2%>'><a href="javascript:parent.list_move('<%=gubun3%>','<%//=gubun4%>','<%//=gubun5%>','<%=gubun6%>');">�縮��</a></td>
	     	    <%}%>			 
             	    <td align="center" width='100'><a href="javascript:parent.list_move('<%=gubun3%>','<%=gubun4%>','<%=gubun5%>','<%=gubun6%>');"><%=d_nm%></a></td>
             	    <td align="right" width='70'><%=rent_way_1_cnt[0]%>&nbsp;</td>
             	    <td align="right" width='70'><%=rent_way_2_cnt[0]%>&nbsp;</td>
             	    <td align="right" width='70'><%=rent_way_t_cnt[0]%>&nbsp;</td>
          	</tr>
          	<%						car_type_cnt++;}}%>		  
          	<tr> 
            	    <td class=title style='text-align:center;' colspan=3>�Ұ�</td>
            	    <td class=title style='text-align:right;'><%=rent_way_1_cnt[3]%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%=rent_way_2_cnt[3]%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%=rent_way_t_cnt[3]%>&nbsp;</td>
          	</tr>		
          	<%		car_type_cnt = 0;
				for(int i = 0 ; i < vt_size1 ; i++){
					Hashtable ht = (Hashtable)vts1.elementAt(i);
					if(String.valueOf(ht.get("CAR_TYPE")).equals("3")){
						rent_way_1_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));
						rent_way_2_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT")));
						rent_way_t_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("CON_MON")));
						
						rent_way_1_cnt[4] += rent_way_1_cnt[0];
						rent_way_2_cnt[4] += rent_way_2_cnt[0];
						rent_way_t_cnt[4] += rent_way_t_cnt[0];
						
						rent_way_1_cnt[1] += rent_way_1_cnt[0];
						rent_way_2_cnt[1] += rent_way_2_cnt[0];
						rent_way_t_cnt[1] += rent_way_t_cnt[0];
						
						gubun3 = "3";
						gubun4 = "";
						gubun5 = "";
						gubun6 = "";
						String d_nm = "";
						if(String.valueOf(ht.get("GOOD")).equals("11")){		d_nm = "��Ʈ �Ϲݽ�";	gubun4 = "1";	gubun5 = "1";
						}else if(String.valueOf(ht.get("GOOD")).equals("12")){		d_nm = "��Ʈ �⺻��";	gubun4 = "1";	gubun5 = "2";
						}else if(String.valueOf(ht.get("GOOD")).equals("21")){		d_nm = "���� �Ϲݽ�";	gubun4 = "2";	gubun5 = "1";
						}else if(String.valueOf(ht.get("GOOD")).equals("22")){		d_nm = "���� �⺻��";	gubun4 = "2";	gubun5 = "2";
						}
		%>
          	<tr> 
          	    <td align="center" width='30'><%= i+1%></td>
		    <%if(car_type_cnt==0){%>
             	    <td align="center" width='60' rowspan='<%=car_type_size3%>'><a href="javascript:parent.list_move('<%=gubun3%>','<%//=gubun4%>','<%//=gubun5%>','<%=gubun6%>');">����</a></td>
		    <%}%>			 			 
             	    <td align="center" width='100'><a href="javascript:parent.list_move('<%=gubun3%>','<%=gubun4%>','<%=gubun5%>','<%=gubun6%>');"><%=d_nm%></a></td>
             	    <td align="right" width='70'><%=rent_way_1_cnt[0]%>&nbsp;</td>
             	    <td align="right" width='70'><%=rent_way_2_cnt[0]%>&nbsp;</td>
             	    <td align="right" width='70'><%=rent_way_t_cnt[0]%>&nbsp;</td>
          	</tr>
          	<%						car_type_cnt++;}}%>		  
          	<tr> 
            	    <td class=title style='text-align:center;' colspan=3>�Ұ�</td>
            	    <td class=title style='text-align:right;'><%=rent_way_1_cnt[4]%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%=rent_way_2_cnt[4]%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%=rent_way_t_cnt[4]%>&nbsp;</td>
          	</tr>				    		  		    
          	<tr> 
            	    <td class=title_p style='text-align:center;' colspan=3>����հ�</td>
            	    <td class=title_p style='text-align:right;'><%=rent_way_1_cnt[1]%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%=rent_way_2_cnt[1]%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%=rent_way_t_cnt[1]%>&nbsp;</td>
          	</tr>		
          	<%		car_type_cnt = 0;
				for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					if(String.valueOf(ht.get("CAR_TYPE")).equals("4")){
						rent_way_1_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));
						rent_way_2_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT")));
						rent_way_t_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("CON_MON")));
						
						rent_way_1_cnt[5] += rent_way_1_cnt[0];
						rent_way_2_cnt[5] += rent_way_2_cnt[0];
						rent_way_t_cnt[5] += rent_way_t_cnt[0];
						
						gubun3 = "";
						gubun4 = "";
						gubun5 = "";
						gubun6 = "";
						String d_nm = "";
						if(String.valueOf(ht.get("GOOD")).equals("1")){			d_nm = "�縮�� ����";	gubun3 = "4"; 	gubun4 = "";	gubun5 = "";
						}else if(String.valueOf(ht.get("GOOD")).equals("2")){		d_nm = "���� �⺻��";	gubun3 = "9"; 	gubun4 = "";	gubun5 = "";
						}
          	%>
          	<tr> 
          	    <td align="center" width='30'><%= i+1%></td>
		    <%if(car_type_cnt==0){%>
             	    <td align="center" width='60' rowspan='<%=car_type_size4%>'><a href="javascript:parent.list_move('<%=gubun3%>','<%//=gubun4%>','<%//=gubun5%>','<%=gubun6%>');">��Ÿ</a></td>
		    <%}%>			 			 
             	    <td align="center" width='100'><a href="javascript:parent.list_move('<%=gubun3%>','<%=gubun4%>','<%=gubun5%>','<%=gubun6%>');"><%=d_nm%></a></td>
             	    <td align="right" width='70'><%=rent_way_1_cnt[0]%>&nbsp;</td>
             	    <td align="right" width='70'><%=rent_way_2_cnt[0]%>&nbsp;</td>
             	    <td align="right" width='70'><%=rent_way_t_cnt[0]%>&nbsp;</td>
          	</tr>
          	<%						car_type_cnt++;}}%>		  
          	<%		
				for(int i = 0 ; i < vt_size3 ; i++){
					Hashtable ht = (Hashtable)vts3.elementAt(i);
					if(String.valueOf(ht.get("CAR_TYPE")).equals("4")){
						rent_way_1_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));
						rent_way_2_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT")));
						rent_way_t_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("CON_MON")));
						
						rent_way_1_cnt[5] += rent_way_1_cnt[0];
						rent_way_2_cnt[5] += rent_way_2_cnt[0];
						rent_way_t_cnt[5] += rent_way_t_cnt[0];
						
						gubun3 = "";
						gubun4 = "";
						gubun5 = "";
						gubun6 = "";
						String d_nm = "";
						if(String.valueOf(ht.get("GOOD")).equals("1")){			d_nm = "�縮�� ����";			gubun3 = "4"; 	gubun4 = "";	gubun5 = "";
						}else if(String.valueOf(ht.get("GOOD")).equals("0")){		d_nm = "���� ����";			gubun3 = "12"; 	gubun4 = "";	gubun5 = "";
						}else if(String.valueOf(ht.get("GOOD")).equals("2")){		d_nm = "���� ����";			gubun3 = "9"; 	gubun4 = "";	gubun5 = "";
						}else if(String.valueOf(ht.get("GOOD")).equals("3")){		d_nm = "�߰� �̿�";			gubun3 = "5"; 	gubun4 = "";	gubun5 = "";
						}else if(String.valueOf(ht.get("GOOD")).equals("4")){		d_nm = "��� �°�";			gubun3 = "6";	gubun4 = "";	gubun5 = "";
						}else if(String.valueOf(ht.get("GOOD")).equals("7")){		d_nm = "�ߵ�����ݹ߻�";		gubun3 = "7";	gubun4 = "";	gubun5 = "";
						}else if(String.valueOf(ht.get("GOOD")).equals("8")){		d_nm = "�ߵ�����ݼ���";		gubun3 = "8";	gubun4 = "";	gubun5 = "";
						}else if(String.valueOf(ht.get("GOOD")).equals("10")){		d_nm = "��������ݹ߻�";		gubun3 = "10";	gubun4 = "";	gubun5 = "";
						}else if(String.valueOf(ht.get("GOOD")).equals("11")){		d_nm = "��������ݼ���";		gubun3 = "11";	gubun4 = "";	gubun5 = "";
						}else if(String.valueOf(ht.get("GOOD")).equals("13")){		d_nm = "�����������";			gubun3 = "13";	gubun4 = "";	gubun5 = "";
						}else if(String.valueOf(ht.get("GOOD")).equals("14")){		d_nm = "�縮���������߰�";		gubun3 = "14";	gubun4 = "";	gubun5 = "";
						}else if(String.valueOf(ht.get("GOOD")).equals("15")){		d_nm = "����氨�������";		gubun3 = "15";	gubun4 = "";	gubun5 = "";
						}else if(String.valueOf(ht.get("GOOD")).equals("16")){		d_nm = "����氨�δ���";		gubun3 = "16";	gubun4 = "";	gubun5 = "";
						}else if(String.valueOf(ht.get("GOOD")).equals("17")){		d_nm = "����Ʈ";			gubun3 = "17";	gubun4 = "";	gubun5 = "";
						}
		%>
          	<tr> 
          	    <td align="center" width='30'><%= i+1%></td>
		    <%if(car_type_cnt==0){%>
             	    <td align="center" width='60' rowspan='<%=car_type_size4%>'><a href="javascript:parent.list_move('<%=gubun3%>','<%//=gubun4%>','<%//=gubun5%>','<%=gubun6%>');">��Ÿ</a></td>
		    <%}%>			 			 
             	    <td align="center" width='100' style="font-size : 7pt;"><a href="javascript:parent.list_move('<%=gubun3%>','<%=gubun4%>','<%=gubun5%>','<%=gubun6%>');"><%=d_nm%></a></td>
             	    <td align="right" width='70'><%=rent_way_1_cnt[0]%>&nbsp;</td>
             	    <td align="right" width='70'><%=rent_way_2_cnt[0]%>&nbsp;</td>
             	    <td align="right" width='70'><%=rent_way_t_cnt[0]%>&nbsp;</td>
          	</tr>
          	<%				car_type_cnt++;}}%>		  		  
          	<tr> 
            	    <td class=title style='text-align:center;' colspan=3>��Ÿ�Ұ�</td>
            	    <td class=title style='text-align:right;'><%=rent_way_1_cnt[5]%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%=rent_way_2_cnt[5]%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%=rent_way_t_cnt[5]%>&nbsp;</td>
          	</tr>					
          	<tr> 
            	    <td class=title_p style='text-align:center;' colspan=3>��ü�հ�</td>
            	    <td class=title_p style='text-align:right;'><%=rent_way_1_cnt[1]+rent_way_1_cnt[5]%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%=rent_way_2_cnt[1]+rent_way_2_cnt[5]%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%=rent_way_t_cnt[1]+rent_way_t_cnt[5]%>&nbsp;</td>
          	</tr>				    		    		  		    
            </table>
        </td>
	<td class='line' width='5570' >
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' >  
                <%	for(int i = 0 ; i < vt_size1 ; i++){
					Hashtable ht = (Hashtable)vts1.elementAt(i);
					
					if(String.valueOf(ht.get("CAR_TYPE")).equals("1")){ //����
					
					rent_way_1_cnt[0] 	= AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));
					rent_way_2_cnt[0] 	= AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT")));
					rent_way_t_cnt[0] 	= AddUtil.parseLong(String.valueOf(ht.get("CON_MON")));
					
					af_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AF_AMT")));
					af_amt2[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AF_AMT2")));
					bc_s_g[0] 		= AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")));
					fee_s_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT")));
					f_af_amt[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT")));
					f_af_amt2[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT2")));
					f_fee_s_amt[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("FEE_S_AMT")));
					f_amt8[0] 			= AddUtil.parseFloat(String.valueOf(ht.get("AMT8")));
					
					point_dc_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("POINT_DC_AMT")));
					f_point_dc_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("POINT_DC_AMT")));
					
					
					
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
					amt45[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT45")));
					amt46[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT46")));
					
					ea_amt[0] 		= amt8[0]-amt21[0]+amt30[0];
					
					
					af_amt[2] 		+= af_amt[0];
					af_amt2[2] 		+= af_amt2[0];
					bc_s_g[2] 		+= bc_s_g[0];
					fee_s_amt[2] 		+= fee_s_amt[0];
					f_af_amt[2] 		+= f_af_amt[0];
					f_af_amt2[2] 		+= f_af_amt2[0];
					f_fee_s_amt[2] 		+= f_fee_s_amt[0];
					f_amt8[2] 		+= f_amt8[0];
					
					point_dc_amt[2] 		+= point_dc_amt[0];
					f_point_dc_amt[2] 		+= f_point_dc_amt[0];
					
					ea_amt[2] 		+= ea_amt[0];
					
					amt1[2] 		+= amt1[0];
					amt2[2] 		+= amt2[0];
					amt3[2] 		+= amt3[0];
					amt4[2] 		+= amt4[0];
					amt5[2] 		+= amt5[0];
					amt6[2] 		+= amt6[0];
					amt7[2] 		+= amt7[0];
					amt8[2] 		+= amt8[0];
					amt9[2] 		+= amt9[0];
					amt10[2] 		+= amt10[0];
					amt11[2] 		+= amt11[0];
					amt12[2] 		+= amt12[0];
					amt13[2] 		+= amt13[0];
					amt14[2] 		+= amt14[0];
					amt15[2] 		+= amt15[0];
					amt16[2] 		+= amt16[0];
					amt17[2] 		+= amt17[0];
					amt18[2] 		+= amt18[0];
					amt19[2] 		+= amt19[0];
					amt20[2] 		+= amt20[0];
					amt21[2] 		+= amt21[0];
					amt22[2] 		+= amt22[0];
					amt23[2] 		+= amt23[0];
					amt24[2] 		+= amt24[0];
					amt25[2] 		+= amt25[0];
					amt26[2] 		+= amt26[0];
					amt27[2] 		+= amt27[0];
					amt28[2] 		+= amt28[0];
					amt29[2] 		+= amt29[0];
					amt30[2] 		+= amt30[0];
					amt31[2] 		+= amt31[0];
					amt32[2] 		+= amt32[0];
					amt33[2] 		+= amt33[0];
					amt34[2] 		+= amt34[0];
					amt35[2] 		+= amt35[0];
					amt36[2] 		+= amt36[0];
					amt37[2] 		+= amt37[0];
					amt39[2] 		+= amt39[0];
					amt40[2] 		+= amt40[0];
					amt41[2] 		+= amt41[0];
					amt43[2] 		+= amt43[0];
					amt44[2] 		+= amt44[0];
					amt45[2] 		+= amt45[0];
					amt46[2] 		+= amt46[0];
					
					af_amt[1] 		+= af_amt[0];
					af_amt2[1] 		+= af_amt2[0];
					bc_s_g[1] 		+= bc_s_g[0];
					fee_s_amt[1] 		+= fee_s_amt[0];
					f_af_amt[1] 		+= f_af_amt[0];
					f_af_amt2[1] 		+= f_af_amt2[0];
					f_fee_s_amt[1] 		+= f_fee_s_amt[0];
					f_amt8[1] 		+= f_amt8[0];
					
					point_dc_amt[1] 		+= point_dc_amt[0];
					f_point_dc_amt[1] 		+= f_point_dc_amt[0];
					
					
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
					amt45[1] 		+= amt45[0];
					amt46[1] 		+= amt46[0];
					
					
					//��������		= a_amt+����ȿ��+�縮������������+���޿�ǰ
    					s_tot[0] 		= a_amt[0] +  ea_amt[0] + amt12[0] + amt16[0];
					//Ȱ����		= (����������+��븶��+��Ÿ����)�Ұ�+�⺻���ּҰ������+�Ϲݽ��ּҰ������
    					ac_amt[0]		= amt8[0]+amt9[0]+amt10[0]; 
					//���Ұ�		= ��������+Ȱ����+���ú��
				   	g_tot[0]		= s_tot[0] + ac_amt[0] + amt15[0];
					//��������������
				    	ave_amt[0] 		= s_tot[0] / rent_way_t_cnt[0];
                %>
                <tr> 
		    <td width="110" align="right"><%=Util.parseDecimal(af_amt2[0])%>&nbsp;</td>  <!--���� -->
	  	    <td width="110" align="right"><%=Util.parseDecimal(af_amt[0])%>&nbsp;</td>  <!--���뿩�����簡ġ -->
	  	    <td width="110" align="right"><%=Util.parseDecimal(ea_amt[0])%>&nbsp;</td>  <!--����ȿ�� -->
	  	    <td width="80" align="right">
		    <% if (  af_amt[0] == 0 ) { %> 0
                    <% } else { %> 
                        <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[0]/f_af_amt[0]*100),2)%>
                    <% } %>&nbsp;
		    </td>  <!--���� -->			
	  	    <td width="100" align="right">
		    <% if (  rent_way_1_cnt[0] == 0 ) { %> 0
                    <% } else { %> 
                        <%=Util.parseDecimal(ea_amt[0]/rent_way_1_cnt[0])%>
                    <% } %>&nbsp;
		    </td>  <!--��翵��ȿ�� -->			
	  	    <td width="100" align="right">
		    <% if (  rent_way_t_cnt[0] == 0 ) { %> 0
                    <% } else { %> 
                        <%=Util.parseDecimal(ea_amt[0]/rent_way_t_cnt[0])%>
                    <% } %>&nbsp;
		    </td>  <!--�����翵��ȿ�� -->			
	  	    <td width="110" align="right"><%=Util.parseDecimal(bc_s_g[0])%>&nbsp;</td>  <!--����뿩�� -->
	  	    <td width="110" align="right"><%=Util.parseDecimal(fee_s_amt[0])%>&nbsp;</td>  <!--���뿩�� -->						
	  	    <td width="80" align="right">
		    <% if (  bc_s_g[0] == 0 ) { %> 0
		    <% } else { %> 
		        <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[0]-f_fee_s_amt[0])/(bc_s_g[0]-amt43[0]-amt44[0]) ) * 100),2)%>
		    <% } %>&nbsp;
	    	    </td>  <!--������ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt1[0])%>&nbsp;</td>  <!--�⺻�İ�����-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt2[0])%>&nbsp;</td>  <!--�Ϲݽİ�����-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt3[0])%>&nbsp;</td>  <!--��븶��-->
		    <td width="110" align="right"><%=Util.parseDecimal(amt34[0])%>&nbsp;</td>  <!--���Ǻ��谡�Ժ�-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt4[0])%>&nbsp;</td>  <!--�縮���ʱ⿵�����-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt5[0])%>&nbsp;</td>  <!--�縮���߰���������-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt6[0])%>&nbsp;</td>  <!-- ī�����ĳ����-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt40[0])%>&nbsp;</td>  <!-- ī�����ĳ��������ݿ���-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt35[0])%>&nbsp;</td>  <!-- ���������-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt41[0])%>&nbsp;</td>  <!-- �������������ݿ���-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt36[0])%>&nbsp;</td>  <!-- �����̰��������-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt39[0])%>&nbsp;</td>  <!-- ������Ʈ�����������-->
            	    <td width="100" align="right"><%=Util.parseDecimal(point_dc_amt[0])%>&nbsp;</td>  <!-- ����Ʈ�����ݾ�(����)-->
            	    <td width="100" align="right">0&nbsp;</td>  <!-- ����Ʈ�����ݾ�(���밪)-->
            	    <td width="100" align="right"><%=Util.parseDecimal(amt46[0])%>&nbsp;</td>  <!-- �縮���������̵�Ź�۷�����ݿ���-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt7[0])%>&nbsp;</td>  <!--��Ÿ-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt8[0])%>&nbsp;</td>  <!--�Ұ� -->
	  	    <td width="80" align="right">
		    <% if (  f_af_amt[0] == 0 ) { %> 0
                    <% } else { %> 
                        <%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[0]/f_af_amt[0]*100),2)%>
                    <% } %>&nbsp;
		    </td>  <!--���뿩���� -->									            
            	    <td width="110" align="right"><%=Util.parseDecimal(amt9[0])%>&nbsp;</td> <!--�⺻���ּҰ������ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt10[0])%>&nbsp;</td> <!--�Ϲݽ��ּҰ������ --> 
            	    <td width="110" align="right"><%=Util.parseDecimal(amt11[0])%>&nbsp;</td> <!--�縮������������ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt12[0])%>&nbsp;</td> <!--�����縮�������� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt13[0])%>&nbsp;</td> <!--����Ŀ�߰�Ź�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt15[0])%>&nbsp;</td> <!--���ú�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt16[0])%>&nbsp;</td> <!--���޿�ǰ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt17[0])%>&nbsp;</td> <!--�����̹ݿ�����ǰ�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt14[0])%>&nbsp;</td> <!--�����ε�Ź�ۺ��  -->			
            	    <td width="110" align="right"><%=Util.parseDecimal(amt18[0])%>&nbsp;</td> <!--�����ε������� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt33[0])%>&nbsp;</td> <!--��Ʈ����⵿���谡�Ժ�->�ӽÿ��ຸ���-->
            	    <td width="100" align="right"><%=Util.parseDecimal(amt46[0])%>&nbsp;</td>  <!-- �縮���������̵�Ź�۷�����ݿ���-->			
            	    <td width="110" align="right"><%=Util.parseDecimal(amt19[0])%>&nbsp;</td> <!--��Ÿ��� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt37[0])%>&nbsp;</td> <!--ī����������������� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt20[0])%>&nbsp;</td> <!--�Ǻ�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt21[0])%>&nbsp;</td> <!--��ġ -->        
            	    <td width="110" align="right"><%=Util.parseDecimal(amt22[0])%>&nbsp;</td> <!--����D/C -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt23[0])%>&nbsp;</td> <!--�߰�D/C -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt24[0])%>&nbsp;</td> <!--�ܰ�����ũ����ȿ�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt25[0])%>&nbsp;</td> <!--�����������ݸ���  -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt26[0])%>&nbsp;</td> <!--����������ݸ��� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt27[0])%>&nbsp;</td> <!--�°������ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt28[0])%>&nbsp;</td> <!--�����    --> 	
            	    <td width="110" align="right"><%=Util.parseDecimal(amt29[0])%>&nbsp;</td> <!--��Ÿ  -->                   
            	    <td width="110" align="right"><%=Util.parseDecimal(amt30[0])%>&nbsp;</td> <!--�Ұ� -->
                </tr>
                <%	}}%>  
                <tr> 
		    <td class=title style='text-align:right;'><%= Util.parseDecimal(af_amt2[2])%>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(af_amt[2])%>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(ea_amt[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'>
		    <% if (  af_amt[2] == 0 ) { %> 0
                    <% } else { %> 
                        <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[2]/f_af_amt[2]*100),2)%>
                    <% } %>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'>
		    <% if (  rent_way_1_cnt[2] == 0 ) { %> 0
                    <% } else { %> 
                        <%=Util.parseDecimal(ea_amt[2]/rent_way_1_cnt[2])%>
                    <% } %>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'>
		    <% if (  rent_way_t_cnt[2] == 0 ) { %> 0
                    <% } else { %> 
                    <%=Util.parseDecimal(ea_amt[2]/rent_way_t_cnt[2])%>
                    <% } %>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(bc_s_g[2])%>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(fee_s_amt[2])%>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'>
		    <% if (  bc_s_g[2] == 0 ) { %> 0
		    <% } else { %> 
		        <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[2]-f_fee_s_amt[2])/(bc_s_g[2]-amt43[2]-amt44[2]) ) * 100),2)%>
		    <% } %>&nbsp;</td>		  												
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt1[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt2[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt3[2])%>&nbsp;</td>
		    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt34[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt4[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt5[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt6[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt40[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt35[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt41[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt36[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt39[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(point_dc_amt[2])%>&nbsp;</td>  <!-- ����Ʈ�����ݾ�(����)-->
            	    <td class=title style='text-align:right;'>0&nbsp;</td>  <!-- ����Ʈ�����ݾ�(���밪)-->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt46[2])%>&nbsp;</td>  <!-- �縮���������̵�Ź�۷�����ݿ���-->
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt7[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt8[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'>
		    <% if (  af_amt[2] == 0 ) { %> 0
                    <% } else { %> 
		        <%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[2]/f_af_amt[2]*100),2)%>
                    <% } %>&nbsp;</td>		  			
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt9[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt10[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt11[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt12[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt13[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt15[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt16[2])%>&nbsp;</td>                       
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt17[2])%>&nbsp;</td>  
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt14[2])%>&nbsp;</td>			
    		    	<td class=title style='text-align:right;'><%= Util.parseDecimal(amt18[2])%>&nbsp;</td> 
    		    	<td class=title style='text-align:right;'><%= Util.parseDecimal(amt33[2])%>&nbsp;</td>
    		    	<td class=title style='text-align:right;'><%=Util.parseDecimal(amt46[2])%>&nbsp;</td>  <!-- �縮���������̵�Ź�۷�����ݿ���--> 			
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt19[2])%>&nbsp;</td> 
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt37[2])%>&nbsp;</td> 
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt20[2])%>&nbsp;</td> 
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt21[2])%>&nbsp;</td>             
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt22[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt23[2])%>&nbsp;</td>  
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt24[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt25[2])%>&nbsp;</td> 
           	    	<td class=title style='text-align:right;'><%= Util.parseDecimal(amt26[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt27[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt28[2])%>&nbsp;</td> 
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt29[2])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt30[2])%>&nbsp;</td>          
                </tr>	    
                <%	for(int i = 0 ; i < vt_size1 ; i++){
					Hashtable ht = (Hashtable)vts1.elementAt(i);
					
					if(String.valueOf(ht.get("CAR_TYPE")).equals("2")){ //�縮��
					
					rent_way_1_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));
					rent_way_2_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT")));
					rent_way_t_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("CON_MON")));
					
					af_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AF_AMT")));
					af_amt2[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AF_AMT2")));
					bc_s_g[0] 		= AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")));
					fee_s_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT")));
					f_af_amt[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT")));
					f_af_amt2[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT2")));
					f_fee_s_amt[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("FEE_S_AMT")));
					f_amt8[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AMT8")));
					
					point_dc_amt[0] 		= 0;
					f_point_dc_amt[0] 		= 0;
					
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
					amt45[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT45")));
					amt46[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT46")));
					
					ea_amt[0] 		= amt8[0]-amt21[0]+amt30[0];
					
					af_amt[3] 		+= af_amt[0];
					af_amt2[3] 		+= af_amt2[0];
					bc_s_g[3] 		+= bc_s_g[0];
					fee_s_amt[3] 		+= fee_s_amt[0];
					f_af_amt[3] 		+= f_af_amt[0];
					f_af_amt2[3] 		+= f_af_amt2[0];
					f_fee_s_amt[3] 		+= f_fee_s_amt[0];
					f_amt8[3] 		+= f_amt8[0];
					ea_amt[3] 		+= ea_amt[0];
					
					point_dc_amt[3] 		+= point_dc_amt[0];
					f_point_dc_amt[3] 		+= f_point_dc_amt[0];
					
					amt1[3] 		+= amt1[0];
					amt2[3] 		+= amt2[0];
					amt3[3] 		+= amt3[0];
					amt4[3] 		+= amt4[0];
					amt5[3] 		+= amt5[0];
					amt6[3] 		+= amt6[0];
					amt7[3] 		+= amt7[0];
					amt8[3] 		+= amt8[0];
					amt9[3] 		+= amt9[0];
					amt10[3] 		+= amt10[0];
					amt11[3] 		+= amt11[0];
					amt12[3] 		+= amt12[0];
					amt13[3] 		+= amt13[0];
					amt14[3] 		+= amt14[0];
					amt15[3] 		+= amt15[0];
					amt16[3] 		+= amt16[0];
					amt17[3] 		+= amt17[0];
					amt18[3] 		+= amt18[0];
					amt19[3] 		+= amt19[0];
					amt20[3] 		+= amt20[0];
					amt21[3] 		+= amt21[0];
					amt22[3] 		+= amt22[0];
					amt23[3] 		+= amt23[0];
					amt24[3] 		+= amt24[0];
					amt25[3] 		+= amt25[0];
					amt26[3] 		+= amt26[0];
					amt27[3] 		+= amt27[0];
					amt28[3] 		+= amt28[0];
					amt29[3] 		+= amt29[0];
					amt30[3] 		+= amt30[0];
					amt31[3] 		+= amt31[0];
					amt32[3] 		+= amt32[0];
					amt33[3] 		+= amt33[0];
					amt34[3] 		+= amt34[0];
					amt35[3] 		+= amt35[0];
					amt36[3] 		+= amt36[0];
					amt37[3] 		+= amt37[0];
					amt39[3] 		+= amt39[0];
					amt40[3] 		+= amt40[0];
					amt41[3] 		+= amt41[0];
					amt43[3] 		+= amt43[0];
					amt44[3] 		+= amt44[0];
					amt45[3] 		+= amt45[0];
					amt46[3] 		+= amt46[0];
					
					af_amt[1] 		+= af_amt[0];
					af_amt2[1] 		+= af_amt2[0];
					bc_s_g[1] 		+= bc_s_g[0];
					fee_s_amt[1] 		+= fee_s_amt[0];
					f_af_amt[1] 		+= f_af_amt[0];
					f_af_amt2[1] 		+= f_af_amt2[0];
					f_fee_s_amt[1] 		+= f_fee_s_amt[0];
					f_amt8[1] 		+= f_amt8[0];
					ea_amt[1] 		+= ea_amt[0];
					
					point_dc_amt[1] 		+= point_dc_amt[0];
					f_point_dc_amt[1] 		+= f_point_dc_amt[0];
					
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
					amt45[1] 		+= amt45[0];
					amt46[1] 		+= amt46[0];
					
					//��������		= a_amt+����ȿ��+�縮������������+���޿�ǰ
    					s_tot[0] 		= a_amt[0] +  ea_amt[0] + amt12[0] + amt16[0];
					//Ȱ����		= (����������+��븶��+��Ÿ����)�Ұ�+�⺻���ּҰ������+�Ϲݽ��ּҰ������
    					ac_amt[0]		= amt8[0]+amt9[0]+amt10[0]; 
					//���Ұ�		= ��������+Ȱ����+���ú��
				    	g_tot[0]		= s_tot[0] + ac_amt[0] + amt15[0];
					//��������������
				    	ave_amt[0] 		= s_tot[0] / rent_way_t_cnt[0];
                %>
                <tr> 
		    <td width="110" align="right"><%=Util.parseDecimal(af_amt2[0])%>&nbsp;</td>  <!--���� -->
	  	    <td width="110" align="right"><%=Util.parseDecimal(af_amt[0])%>&nbsp;</td>  <!--���뿩�����簡ġ -->
	  	    <td width="110" align="right"><%=Util.parseDecimal(ea_amt[0])%>&nbsp;</td>  <!--����ȿ�� -->
	  	    <td width="80" align="right">
		    <% if (  af_amt[0] == 0 ) { %> 0
                    <% } else { %> 
                        <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[0]/f_af_amt[0]*100),2)%>
                    <% } %>&nbsp;
		    </td>  <!--���� -->			
  		    <td width="100" align="right">
		    <% if (  rent_way_1_cnt[0] == 0 ) { %> 0
                    <% } else { %> 
                        <%=Util.parseDecimal(ea_amt[0]/rent_way_1_cnt[0])%>
                    <% } %>&nbsp;
		    </td>  <!--��翵��ȿ�� -->			
  		    <td width="100" align="right">
		    <% if (  rent_way_t_cnt[0] == 0 ) { %> 0
                    <% } else { %> 
                        <%=Util.parseDecimal(ea_amt[0]/rent_way_t_cnt[0])%>
                    <% } %>&nbsp;
		    </td>  <!--�����翵��ȿ�� -->			
  		    <td width="110" align="right"><%=Util.parseDecimal(bc_s_g[0])%>&nbsp;</td>  <!--����뿩�� -->
  		    <td width="110" align="right"><%=Util.parseDecimal(fee_s_amt[0])%>&nbsp;</td>  <!--���뿩�� -->						
  		    <td width="80" align="right">
		    <% if (  bc_s_g[0] == 0 ) { %> 0
		    <% } else { %> 
		         <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[0]-f_fee_s_amt[0])/(bc_s_g[0]-amt43[0]-amt44[0]) ) * 100),2)%>
		    <% } %>&nbsp;
		    </td>  <!--������ -->
       	            <td width="110" align="right"><%=Util.parseDecimal(amt1[0])%>&nbsp;</td>  <!--�⺻�İ�����-->
       	            <td width="110" align="right"><%=Util.parseDecimal(amt2[0])%>&nbsp;</td>  <!--�Ϲݽİ�����-->
       	            <td width="110" align="right"><%=Util.parseDecimal(amt3[0])%>&nbsp;</td>  <!--��븶��-->
		    <td width="110" align="right"><%=Util.parseDecimal(amt34[0])%>&nbsp;</td>  <!--���Ǻ��谡�Ժ�-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt4[0])%>&nbsp;</td>  <!--�縮���ʱ⿵�����-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt5[0])%>&nbsp;</td>  <!--�縮���߰���������-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt6[0])%>&nbsp;</td>  <!-- ī�����ĳ����-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt40[0])%>&nbsp;</td>  <!-- ī�����ĳ��������ݿ���-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt35[0])%>&nbsp;</td>  <!-- ���������-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt41[0])%>&nbsp;</td>  <!-- �������������ݿ���-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt36[0])%>&nbsp;</td>  <!-- �����̰��������-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt39[0])%>&nbsp;</td>  <!-- ������Ʈ�����������-->
            	    <td width="100" align="right"><%=Util.parseDecimal(point_dc_amt[0])%>&nbsp;</td>  <!-- ����Ʈ�����ݾ�(����)-->
            	    <td width="100" align="right">0&nbsp;</td>  <!-- ����Ʈ�����ݾ�(���밪)-->
            	    <td width="100" align="right"><%=Util.parseDecimal(amt46[0])%>&nbsp;</td>  <!-- �縮���������̵�Ź�۷�����ݿ���-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt7[0])%>&nbsp;</td>  <!--��Ÿ-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt8[0])%>&nbsp;</td>  <!--�Ұ� -->
	  	    <td width="80" align="right">
		    <% if (  f_af_amt[0] == 0 ) { %> 0
                    <% } else { %> 
                        <%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[0]/f_af_amt[0]*100),2)%>
                    <% } %>&nbsp;
		    </td>  <!--���뿩���� -->									            
            	    <td width="110" align="right"><%=Util.parseDecimal(amt9[0])%>&nbsp;</td> <!--�⺻���ּҰ������ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt10[0])%>&nbsp;</td> <!--�Ϲݽ��ּҰ������ --> 
            	    <td width="110" align="right"><%=Util.parseDecimal(amt11[0])%>&nbsp;</td> <!--�縮������������ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt12[0])%>&nbsp;</td> <!--�����縮�������� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt13[0])%>&nbsp;</td> <!--����Ŀ�߰�Ź�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt15[0])%>&nbsp;</td> <!--���ú�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt16[0])%>&nbsp;</td> <!--���޿�ǰ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt17[0])%>&nbsp;</td> <!--�����̹ݿ�����ǰ�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt14[0])%>&nbsp;</td> <!--�����ε�Ź�ۺ��  -->			
            	    <td width="110" align="right"><%=Util.parseDecimal(amt18[0])%>&nbsp;</td> <!--�����ε������� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt33[0])%>&nbsp;</td> <!--��Ʈ����⵿���谡�Ժ�->�ӽÿ��ຸ���-->		
            	    <td width="100" align="right"><%=Util.parseDecimal(amt46[0])%>&nbsp;</td>  <!-- �縮���������̵�Ź�۷�����ݿ���-->	
            	    <td width="110" align="right"><%=Util.parseDecimal(amt19[0])%>&nbsp;</td> <!--��Ÿ��� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt37[0])%>&nbsp;</td> <!--ī����������������� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt20[0])%>&nbsp;</td> <!--�Ǻ�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt21[0])%>&nbsp;</td> <!--��ġ -->        
            	    <td width="110" align="right"><%=Util.parseDecimal(amt22[0])%>&nbsp;</td> <!--����D/C -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt23[0])%>&nbsp;</td> <!--�߰�D/C -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt24[0])%>&nbsp;</td> <!--�ܰ�����ũ����ȿ�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt25[0])%>&nbsp;</td> <!--�����������ݸ���  -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt26[0])%>&nbsp;</td> <!--����������ݸ��� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt27[0])%>&nbsp;</td> <!--�°������ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt28[0])%>&nbsp;</td> <!--�����    --> 	
            	    <td width="110" align="right"><%=Util.parseDecimal(amt29[0])%>&nbsp;</td> <!--��Ÿ  -->                   
            	    <td width="110" align="right"><%=Util.parseDecimal(amt30[0])%>&nbsp;</td> <!--�Ұ� -->
                </tr>
                <%	}}%>  
                <tr> 
		    <td class=title style='text-align:right;'><%= Util.parseDecimal(af_amt2[3])%>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(af_amt[3])%>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(ea_amt[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'>
		    <% if (  af_amt[3] == 0 ) { %> 0
                    <% } else { %> 
                        <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[3]/f_af_amt[3]*100),2)%>
                    <% } %>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'>
		    <% if (  rent_way_1_cnt[3] == 0 ) { %> 0
                    <% } else { %> 
                        <%=Util.parseDecimal(ea_amt[3]/rent_way_1_cnt[3])%>
                    <% } %>&nbsp;</td>		  
           	    <td class=title style='text-align:right;'>
		    <% if (  rent_way_t_cnt[3] == 0 ) { %> 0
                    <% } else { %> 
                        <%=Util.parseDecimal(ea_amt[3]/rent_way_t_cnt[3])%>
                    <% } %>&nbsp;</td>		  
           	    <td class=title style='text-align:right;'><%= Util.parseDecimal(bc_s_g[3])%>&nbsp;</td>		  
           	    <td class=title style='text-align:right;'><%= Util.parseDecimal(fee_s_amt[3])%>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'>
		    <% if (  bc_s_g[3] == 0 ) { %> 0
		    <% } else { %> 
		        <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[3]-f_fee_s_amt[3])/(bc_s_g[3]-amt43[3]-amt44[3]) ) * 100),2)%>
		    <% } %>&nbsp;</td>		  												
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt1[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt2[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt3[3])%>&nbsp;</td>
		    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt34[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt4[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt5[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt6[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt40[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt35[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt41[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt36[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt39[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(point_dc_amt[3])%>&nbsp;</td>  <!-- ����Ʈ�����ݾ�(����)-->
            	    <td class=title style='text-align:right;'>0&nbsp;</td>  <!-- ����Ʈ�����ݾ�(���밪)-->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt46[3])%>&nbsp;</td>  <!-- �縮���������̵�Ź�۷�����ݿ���-->
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt7[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt8[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'>
		    <% if (  af_amt[3] == 0 ) { %> 0
                    <% } else { %> 
			<%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[3]/f_af_amt[3]*100),2)%>
                    <% } %>&nbsp;</td>		  			
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt9[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt10[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt11[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt12[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt13[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt15[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt16[3])%>&nbsp;</td>                       
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt17[3])%>&nbsp;</td>  
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt14[3])%>&nbsp;</td>			
    		    	<td class=title style='text-align:right;'><%= Util.parseDecimal(amt18[3])%>&nbsp;</td> 
    		    	<td class=title style='text-align:right;'><%= Util.parseDecimal(amt33[3])%>&nbsp;</td> 		
    		        <td class=title style='text-align:right;'><%=Util.parseDecimal(amt46[3])%>&nbsp;</td>  <!-- �縮���������̵�Ź�۷�����ݿ���-->	
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt19[3])%>&nbsp;</td> 
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt37[3])%>&nbsp;</td> 
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt20[3])%>&nbsp;</td> 
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt21[3])%>&nbsp;</td>             
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt22[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt23[3])%>&nbsp;</td>  
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt24[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt25[3])%>&nbsp;</td> 
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt26[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt27[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt28[3])%>&nbsp;</td> 
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt29[3])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt30[3])%>&nbsp;</td>          
                </tr>	  
                <%	for(int i = 0 ; i < vt_size1 ; i++){
					Hashtable ht = (Hashtable)vts1.elementAt(i);
					
					if(String.valueOf(ht.get("CAR_TYPE")).equals("3")){ //����
					
					rent_way_1_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));
					rent_way_2_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT")));
					rent_way_t_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("CON_MON")));
					
					af_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AF_AMT")));
					af_amt2[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AF_AMT2")));
					bc_s_g[0] 		= AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")));
					fee_s_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT")));
					f_af_amt[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT")));
					f_af_amt2[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT2")));
					f_fee_s_amt[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("FEE_S_AMT")));
					f_amt8[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AMT8")));
					
					point_dc_amt[0] 		= 0;
					f_point_dc_amt[0] 		= 0;
					
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
					amt45[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT45")));	
					amt46[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT46")));	
					
					ea_amt[0] 		= amt8[0]-amt21[0]+amt30[0];
					
					af_amt[4] 		+= af_amt[0];
					af_amt2[4] 		+= af_amt2[0];
					bc_s_g[4] 		+= bc_s_g[0];
					fee_s_amt[4] 		+= fee_s_amt[0];
					f_af_amt[4] 		+= f_af_amt[0];
					f_af_amt2[4] 		+= f_af_amt2[0];
					f_fee_s_amt[4] 		+= f_fee_s_amt[0];
					f_amt8[4] 		+= f_amt8[0];
					ea_amt[4] 		+= ea_amt[0];
					
					point_dc_amt[4] 		+= point_dc_amt[0];
					f_point_dc_amt[4] 		+= f_point_dc_amt[0];
					
					amt1[4] 		+= amt1[0];
					amt2[4] 		+= amt2[0];
					amt3[4] 		+= amt3[0];
					amt4[4] 		+= amt4[0];
					amt5[4] 		+= amt5[0];
					amt6[4] 		+= amt6[0];
					amt7[4] 		+= amt7[0];
					amt8[4] 		+= amt8[0];
					amt9[4] 		+= amt9[0];
					amt10[4] 		+= amt10[0];
					amt11[4] 		+= amt11[0];
					amt12[4] 		+= amt12[0];
					amt13[4] 		+= amt13[0];
					amt14[4] 		+= amt14[0];
					amt15[4] 		+= amt15[0];
					amt16[4] 		+= amt16[0];
					amt17[4] 		+= amt17[0];
					amt18[4] 		+= amt18[0];
					amt19[4] 		+= amt19[0];
					amt20[4] 		+= amt20[0];
					amt21[4] 		+= amt21[0];
					amt22[4] 		+= amt22[0];
					amt23[4] 		+= amt23[0];
					amt24[4] 		+= amt24[0];
					amt25[4] 		+= amt25[0];
					amt26[4] 		+= amt26[0];
					amt27[4] 		+= amt27[0];
					amt28[4] 		+= amt28[0];
					amt29[4] 		+= amt29[0];
					amt30[4] 		+= amt30[0];
					amt31[4] 		+= amt31[0];
					amt32[4] 		+= amt32[0];
					amt33[4] 		+= amt33[0];
					amt34[4] 		+= amt34[0];
					amt35[4] 		+= amt35[0];
					amt36[4] 		+= amt36[0];
					amt37[4] 		+= amt37[0];
					amt39[4] 		+= amt39[0];
					amt40[4] 		+= amt40[0];
					amt41[4] 		+= amt41[0];
					amt43[4] 		+= amt43[0];
					amt44[4] 		+= amt44[0];
					amt45[4] 		+= amt45[0];
					amt46[4] 		+= amt46[0];
					
					af_amt[1] 		+= af_amt[0];
					af_amt2[1] 		+= af_amt2[0];
					bc_s_g[1] 		+= bc_s_g[0];
					fee_s_amt[1] 		+= fee_s_amt[0];
					f_af_amt[1] 		+= f_af_amt[0];
					f_af_amt2[1] 		+= f_af_amt2[0];
					f_fee_s_amt[1] 		+= f_fee_s_amt[0];
					f_amt8[1] 		+= f_amt8[0];
					ea_amt[1] 		+= ea_amt[0];
					
					point_dc_amt[1] 		+= point_dc_amt[0];
					f_point_dc_amt[1] 		+= f_point_dc_amt[0];
					
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
					amt45[1] 		+= amt45[0];
					amt46[1] 		+= amt46[0];
					
					//��������		= a_amt+����ȿ��+�縮������������+���޿�ǰ
    					s_tot[0] 		= a_amt[0] +  ea_amt[0] + amt12[0] + amt16[0];
					//Ȱ����		= (����������+��븶��+��Ÿ����)�Ұ�+�⺻���ּҰ������+�Ϲݽ��ּҰ������
    					ac_amt[0]		= amt8[0]+amt9[0]+amt10[0]; 
					//���Ұ�		= ��������+Ȱ����+���ú��
				    	g_tot[0]		= s_tot[0] + ac_amt[0] + amt15[0];
					//��������������
				    	ave_amt[0] 		= s_tot[0] / rent_way_t_cnt[0];
                %>
                <tr> 
		    <td width="110" align="right"><%=Util.parseDecimal(af_amt2[0])%>&nbsp;</td>  <!--���� -->
	  	    <td width="110" align="right"><%=Util.parseDecimal(af_amt[0])%>&nbsp;</td>  <!--���뿩�����簡ġ -->
	  	    <td width="110" align="right"><%=Util.parseDecimal(ea_amt[0])%>&nbsp;</td>  <!--����ȿ�� -->
	  	    <td width="80" align="right">
		    <% if (  af_amt[0] == 0 ) { %> 0
                    <% } else { %> 
                        <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[0]/f_af_amt[0]*100),2)%>
                    <% } %>&nbsp;
		    </td>  <!--���� -->			
	  	    <td width="100" align="right">
		    <% if (  rent_way_1_cnt[0] == 0 ) { %> 0
                    <% } else { %> 
                    <%=Util.parseDecimal(ea_amt[0]/rent_way_1_cnt[0])%>
                    <% } %>&nbsp;
		    </td>  <!--��翵��ȿ�� -->			
	  	    <td width="100" align="right">
		    <% if (  rent_way_t_cnt[0] == 0 ) { %> 0
                    <% } else { %> 
                    <%=Util.parseDecimal(ea_amt[0]/rent_way_t_cnt[0])%>
                    <% } %>&nbsp;
		    </td>  <!--�����翵��ȿ�� -->			
	  	    <td width="110" align="right"><%=Util.parseDecimal(bc_s_g[0])%>&nbsp;</td>  <!--����뿩�� -->
	  	    <td width="110" align="right"><%=Util.parseDecimal(fee_s_amt[0])%>&nbsp;</td>  <!--���뿩�� -->						
	  	    <td width="80" align="right">
		    <% if (  bc_s_g[0] == 0 ) { %> 0
		    <% } else { %> 
			<%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[0]-f_fee_s_amt[0])/(bc_s_g[0]-amt43[0]-amt44[0]) ) * 100),2)%>
		    <% } %>&nbsp;
		    </td>  <!--������ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt1[0])%>&nbsp;</td>  <!--�⺻�İ�����-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt2[0])%>&nbsp;</td>  <!--�Ϲݽİ�����-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt3[0])%>&nbsp;</td>  <!--��븶��-->
		    <td width="110" align="right"><%=Util.parseDecimal(amt34[0])%>&nbsp;</td>  <!--���Ǻ��谡�Ժ�-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt4[0])%>&nbsp;</td>  <!--�縮���ʱ⿵�����-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt5[0])%>&nbsp;</td>  <!--�縮���߰���������-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt6[0])%>&nbsp;</td>  <!-- ī�����ĳ����-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt40[0])%>&nbsp;</td>  <!-- ī�����ĳ��������ݿ���-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt35[0])%>&nbsp;</td>  <!-- ���������-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt41[0])%>&nbsp;</td>  <!-- �������������ݿ���-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt36[0])%>&nbsp;</td>  <!-- �����̰��������-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt39[0])%>&nbsp;</td>  <!-- ������Ʈ�����������-->
            	    <td width="100" align="right"><%=Util.parseDecimal(point_dc_amt[0])%>&nbsp;</td>  <!-- ����Ʈ�����ݾ�(����)-->
            	    <td width="100" align="right">0&nbsp;</td>  <!-- ����Ʈ�����ݾ�(���밪)-->
            	    <td width="100" align="right"><%=Util.parseDecimal(amt46[0])%>&nbsp;</td>  <!-- �縮���������̵�Ź�۷�����ݿ���-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt7[0])%>&nbsp;</td>  <!--��Ÿ-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt8[0])%>&nbsp;</td>  <!--�Ұ� -->
	  	    <td width="80" align="right">
		    <% if (  f_af_amt[0] == 0 ) { %> 0
                    <% } else { %> 
                    <%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[0]/f_af_amt[0]*100),2)%>
                    <% } %>&nbsp;
		    </td>  <!--���뿩���� -->									            
            	    <td width="110" align="right"><%=Util.parseDecimal(amt9[0])%>&nbsp;</td> <!--�⺻���ּҰ������ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt10[0])%>&nbsp;</td> <!--�Ϲݽ��ּҰ������ --> 
            	    <td width="110" align="right"><%=Util.parseDecimal(amt11[0])%>&nbsp;</td> <!--�縮������������ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt12[0])%>&nbsp;</td> <!--�����縮�������� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt13[0])%>&nbsp;</td> <!--����Ŀ�߰�Ź�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt15[0])%>&nbsp;</td> <!--���ú�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt16[0])%>&nbsp;</td> <!--���޿�ǰ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt17[0])%>&nbsp;</td> <!--�����̹ݿ�����ǰ�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt14[0])%>&nbsp;</td> <!--�����ε�Ź�ۺ��  -->			
            	    <td width="110" align="right"><%=Util.parseDecimal(amt18[0])%>&nbsp;</td> <!--�����ε������� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt33[0])%>&nbsp;</td> <!--��Ʈ����⵿���谡�Ժ�->�ӽÿ��ຸ���-->
            	    <td width="100" align="right"><%=Util.parseDecimal(amt46[0])%>&nbsp;</td>  <!-- �縮���������̵�Ź�۷�����ݿ���-->			
           	    	<td width="110" align="right"><%=Util.parseDecimal(amt19[0])%>&nbsp;</td> <!--��Ÿ��� -->
           	    	<td width="110" align="right"><%=Util.parseDecimal(amt37[0])%>&nbsp;</td> <!--��Ÿ��� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt20[0])%>&nbsp;</td> <!--�Ǻ�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt21[0])%>&nbsp;</td> <!--��ġ -->        
            	    <td width="110" align="right"><%=Util.parseDecimal(amt22[0])%>&nbsp;</td> <!--����D/C -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt23[0])%>&nbsp;</td> <!--�߰�D/C -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt24[0])%>&nbsp;</td> <!--�ܰ�����ũ����ȿ�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt25[0])%>&nbsp;</td> <!--�����������ݸ���  -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt26[0])%>&nbsp;</td> <!--����������ݸ��� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt27[0])%>&nbsp;</td> <!--�°������ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt28[0])%>&nbsp;</td> <!--�����    --> 	
            	    <td width="110" align="right"><%=Util.parseDecimal(amt29[0])%>&nbsp;</td> <!--��Ÿ  -->                   
            	    <td width="110" align="right"><%=Util.parseDecimal(amt30[0])%>&nbsp;</td> <!--�Ұ� -->
                </tr>
                <%	}}%>  
                <tr> 
		    <td class=title style='text-align:right;'><%= Util.parseDecimal(af_amt2[4])%>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(af_amt[4])%>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(ea_amt[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'>
		    <% if (  af_amt[4] == 0 ) { %> 0
                    <% } else { %> 
                    <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[4]/f_af_amt[4]*100),2)%>
                    <% } %>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'>
		    <% if (  rent_way_1_cnt[4] == 0 ) { %> 0
                    <% } else { %> 
                    <%=Util.parseDecimal(ea_amt[4]/rent_way_1_cnt[4])%>
                    <% } %>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'>
		    <% if (  rent_way_t_cnt[4] == 0 ) { %> 0
                    <% } else { %> 
                    <%=Util.parseDecimal(ea_amt[4]/rent_way_t_cnt[4])%>
                    <% } %>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(bc_s_g[4])%>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(fee_s_amt[4])%>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'>
		    <% if (  bc_s_g[4] == 0 ) { %> 0
		    <% } else { %> 
		    <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[4]-f_fee_s_amt[4])/(bc_s_g[4]-amt43[4]-amt44[4]) ) * 100),2)%>
		    <% } %>&nbsp;</td>		  												
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt1[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt2[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt3[4])%>&nbsp;</td>
		    		<td class=title style='text-align:right;'><%= Util.parseDecimal(amt34[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt4[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt5[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt6[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt40[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt35[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt41[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt36[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt39[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(point_dc_amt[4])%>&nbsp;</td>  <!-- ����Ʈ�����ݾ�(����)-->
            	    <td class=title style='text-align:right;'>0&nbsp;</td>  <!-- ����Ʈ�����ݾ�(���밪)-->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt46[4])%>&nbsp;</td>  <!-- �縮���������̵�Ź�۷�����ݿ���-->
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt7[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt8[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'>
		    <% if (  af_amt[4] == 0 ) { %> 0
                    <% } else { %> 
		        <%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[4]/f_af_amt[4]*100),2)%>
                    <% } %>&nbsp;</td>		  			
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt9[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt10[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt11[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt12[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt13[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt15[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt16[4])%>&nbsp;</td>                       
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt17[4])%>&nbsp;</td>  
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt14[4])%>&nbsp;</td>			
    		    	<td class=title style='text-align:right;'><%= Util.parseDecimal(amt18[4])%>&nbsp;</td> 
    		    	<td class=title style='text-align:right;'><%= Util.parseDecimal(amt33[4])%>&nbsp;</td>
    		    	<td class=title style='text-align:right;'><%=Util.parseDecimal(amt46[4])%>&nbsp;</td>  <!-- �縮���������̵�Ź�۷�����ݿ���--> 			
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt19[4])%>&nbsp;</td> 
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt37[4])%>&nbsp;</td> 
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt20[4])%>&nbsp;</td> 
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt21[4])%>&nbsp;</td>             
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt22[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt23[4])%>&nbsp;</td>  
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt24[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt25[4])%>&nbsp;</td> 
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt26[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt27[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt28[4])%>&nbsp;</td> 
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt29[4])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt30[4])%>&nbsp;</td>          
                </tr>	  		  		    				  
                <tr> 
		    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(af_amt2[1])%>&nbsp;</td>		  
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(af_amt[1])%>&nbsp;</td>		  
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(ea_amt[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'>
		    <% if (  af_amt[1] == 0 ) { %> 0
                    <% } else { %> 
                        <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[1]/f_af_amt[1]*100),2)%>
                    <% } %>&nbsp;</td>		  
            	    <td class=title_p style='text-align:right;'>
		    <% if (  rent_way_1_cnt[1] == 0 ) { %> 0
                    <% } else { %> 
                        <%=Util.parseDecimal(ea_amt[1]/rent_way_1_cnt[1])%>
                    <% } %>&nbsp;</td>		  
            	    <td class=title_p style='text-align:right;'>
		    <% if (  rent_way_t_cnt[1] == 0 ) { %> 0
                    <% } else { %> 
                        <%=Util.parseDecimal(ea_amt[1]/rent_way_t_cnt[1])%>
                    <% } %>&nbsp;</td>		  
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(bc_s_g[1])%>&nbsp;</td>		  
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(fee_s_amt[1])%>&nbsp;</td>		  
            	    <td class=title_p style='text-align:right;'>
		    <% if (  bc_s_g[1] == 0 ) { %> 0
		    <% } else { %> 
		        <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[1]-f_fee_s_amt[1])/(bc_s_g[1]-amt43[1]-amt44[1]) ) * 100),2)%>
		    <% } %>&nbsp;</td>		  												
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt1[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt2[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt3[1])%>&nbsp;</td>
		    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt34[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt4[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt5[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt6[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt40[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt35[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt41[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt36[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt39[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%=Util.parseDecimal(point_dc_amt[1])%>&nbsp;</td>  <!-- ����Ʈ�����ݾ�(����)-->
            	    <td class=title_p style='text-align:right;'>0&nbsp;</td>  <!-- ����Ʈ�����ݾ�(���밪)-->
            	    <td class=title_p style='text-align:right;'><%=Util.parseDecimal(amt46[1])%>&nbsp;</td>  <!-- �縮���������̵�Ź�۷�����ݿ���-->
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt7[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt8[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'>
		    <% if (  af_amt[1] == 0 ) { %> 0
                    <% } else { %> 
			<%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[1]/f_af_amt[1]*100),2)%>
                    <% } %>&nbsp;</td>		  			
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt9[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt10[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt11[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt12[1])%>&nbsp;</td>
           	    	<td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt13[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt15[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt16[1])%>&nbsp;</td>                       
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt17[1])%>&nbsp;</td>  
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt14[1])%>&nbsp;</td>			
    		    	<td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt18[1])%>&nbsp;</td> 
    		    	<td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt33[1])%>&nbsp;</td> 	
    		    	<td class=title_p style='text-align:right;'><%=Util.parseDecimal(amt46[1])%>&nbsp;</td>  <!-- �縮���������̵�Ź�۷�����ݿ���-->		
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt19[1])%>&nbsp;</td> 
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt37[1])%>&nbsp;</td> 
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt20[1])%>&nbsp;</td> 
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt21[1])%>&nbsp;</td>             
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt22[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt23[1])%>&nbsp;</td>  
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt24[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt25[1])%>&nbsp;</td> 
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt26[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt27[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt28[1])%>&nbsp;</td> 
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt29[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt30[1])%>&nbsp;</td>          
                </tr>	
                <%	//��Ÿ-�縮��/��������
		  		for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					
					if(String.valueOf(ht.get("CAR_TYPE")).equals("4")){
					
					rent_way_1_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));
					rent_way_2_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT")));
					rent_way_t_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("CON_MON")));
					
					af_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AF_AMT")));
					af_amt2[0] 		= 0;
					bc_s_g[0] 		= AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")));
					fee_s_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT")));
					f_af_amt[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT")));
					f_af_amt2[0] 		= 0;
					f_fee_s_amt[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("FEE_S_AMT")));
					f_amt8[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AMT8")));
					
					point_dc_amt[0] 		= 0;
					f_point_dc_amt[0] 		= 0;
					
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
					amt45[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT45")));
					amt46[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT46")));
					
					ea_amt[0] 		= amt8[0]-amt21[0]+amt30[0];
					
					af_amt[5] 		+= af_amt[0];
					af_amt2[5] 		+= af_amt2[0];
					bc_s_g[5] 		+= bc_s_g[0];
					fee_s_amt[5] 		+= fee_s_amt[0];
					f_af_amt[5] 		+= f_af_amt[0];
					f_af_amt2[5] 		+= f_af_amt2[0];
					f_fee_s_amt[5] 		+= f_fee_s_amt[0];
					f_amt8[5] 		+= f_amt8[0];
					ea_amt[5] 		+= ea_amt[0];
					
					point_dc_amt[5] 		+= point_dc_amt[0];
					f_point_dc_amt[5] 		+= f_point_dc_amt[0];
					
					amt1[5] 		+= amt1[0];
					amt2[5] 		+= amt2[0];
					amt3[5] 		+= amt3[0];
					amt4[5] 		+= amt4[0];
					amt5[5] 		+= amt5[0];
					amt6[5] 		+= amt6[0];
					amt7[5] 		+= amt7[0];
					amt8[5] 		+= amt8[0];
					amt9[5] 		+= amt9[0];
					amt10[5] 		+= amt10[0];
					amt11[5] 		+= amt11[0];
					amt12[5] 		+= amt12[0];
					amt13[5] 		+= amt13[0];
					amt14[5] 		+= amt14[0];
					amt15[5] 		+= amt15[0];
					amt16[5] 		+= amt16[0];
					amt17[5] 		+= amt17[0];
					amt18[5] 		+= amt18[0];
					amt19[5] 		+= amt19[0];
					amt20[5] 		+= amt20[0];
					amt21[5] 		+= amt21[0];
					amt22[5] 		+= amt22[0];
					amt23[5] 		+= amt23[0];
					amt24[5] 		+= amt24[0];
					amt25[5] 		+= amt25[0];
					amt26[5] 		+= amt26[0];
					amt27[5] 		+= amt27[0];
					amt28[5] 		+= amt28[0];
					amt29[5] 		+= amt29[0];
					amt30[5] 		+= amt30[0];
					amt31[5] 		+= amt31[0];
					amt32[5] 		+= amt32[0];
					amt33[5] 		+= amt33[0];
					amt34[5] 		+= amt34[0];
					amt35[5] 		+= amt35[0];
					amt36[5] 		+= amt36[0];
					amt37[5] 		+= amt37[0];
					amt39[5] 		+= amt39[0];
					amt40[5] 		+= amt40[0];
					amt41[5] 		+= amt41[0];
					amt43[5] 		+= amt43[0];
					amt44[5] 		+= amt44[0];
					amt45[5] 		+= amt45[0];
					amt46[5] 		+= amt46[0];
					
					af_amt[1] 		+= af_amt[0];
					af_amt2[1] 		+= af_amt2[0];
					bc_s_g[1] 		+= bc_s_g[0];
					fee_s_amt[1] 		+= fee_s_amt[0];
					f_af_amt[1] 		+= f_af_amt[0];
					f_af_amt2[1] 		+= f_af_amt2[0];
					f_fee_s_amt[1] 		+= f_fee_s_amt[0];
					f_amt8[1] 		+= f_amt8[0];
					ea_amt[1] 		+= ea_amt[0];
					
					point_dc_amt[1] 		+= point_dc_amt[0];
					f_point_dc_amt[1] 		+= f_point_dc_amt[0];
					
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
					amt45[1] 		+= amt45[0];
					amt46[1] 		+= amt46[0];
					
					//��������		= a_amt+����ȿ��+�縮������������+���޿�ǰ
    					s_tot[0] 		= a_amt[0] +  ea_amt[0] + amt12[0] + amt16[0];
					//Ȱ����		= (����������+��븶��+��Ÿ����)�Ұ�+�⺻���ּҰ������+�Ϲݽ��ּҰ������
    					ac_amt[0]		= amt8[0]+amt9[0]+amt10[0]; 
					//���Ұ�		= ��������+Ȱ����+���ú��
				    	g_tot[0]		= s_tot[0] + ac_amt[0] + amt15[0];
					//��������������
				    	ave_amt[0] 		= s_tot[0] / rent_way_t_cnt[0];
					
                %>
                <tr> 
		    <td width="110" align="right">&nbsp;</td>  <!--���� -->
	  	    <td width="110" align="right"><%=Util.parseDecimal(af_amt[0])%>&nbsp;</td>  <!--���뿩�����簡ġ -->
	  	    <td width="110" align="right"><%=Util.parseDecimal(ea_amt[0])%>&nbsp;</td>  <!--����ȿ�� -->
	  	    <td width="80" align="right">
		    <% if (  af_amt[0] == 0 ) { %> 0
                    <% } else { %> 
                        <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[0]/f_af_amt[0]*100),2)%>
                    <% } %>&nbsp;
		    </td>  <!--���� -->			
	  	    <td width="100" align="right">
		    <% if (  rent_way_1_cnt[0] == 0 ) { %> 0
                    <% } else { %> 
                        <%=Util.parseDecimal(ea_amt[0]/rent_way_1_cnt[0])%>
                    <% } %>&nbsp;
		    </td>  <!--��翵��ȿ�� -->			
	  	    <td width="100" align="right">
		    <% if (  rent_way_t_cnt[0] == 0 ) { %> 0
                    <% } else { %> 
                        <%=Util.parseDecimal(ea_amt[0]/rent_way_t_cnt[0])%>
                    <% } %>&nbsp;
		    </td>  <!--�����翵��ȿ�� -->			
	  	    <td width="110" align="right"><%=Util.parseDecimal(bc_s_g[0])%>&nbsp;</td>  <!--����뿩�� -->
	  	    <td width="110" align="right"><%=Util.parseDecimal(fee_s_amt[0])%>&nbsp;</td>  <!--���뿩�� -->						
	  	    <td width="80" align="right">
		    <% if (  bc_s_g[0] == 0 ) { %> 0
		    <% } else { %> 
		    <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[0]-f_fee_s_amt[0])/(bc_s_g[0]-amt43[0]-amt44[0]) ) * 100),2)%>
		    <% } %>&nbsp;
		    </td>  <!--������ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt1[0])%>&nbsp;</td>  <!--�⺻�İ�����-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt2[0])%>&nbsp;</td>  <!--�Ϲݽİ�����-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt3[0])%>&nbsp;</td>  <!--��븶��-->
		    		<td width="110" align="right"><%=Util.parseDecimal(amt34[0])%>&nbsp;</td>  <!--���Ǻ��谡�Ժ�-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt4[0])%>&nbsp;</td>  <!--�縮���ʱ⿵�����-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt5[0])%>&nbsp;</td>  <!--�縮���߰���������-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt6[0])%>&nbsp;</td>  <!-- ī�����ĳ����-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt40[0])%>&nbsp;</td>  <!-- ī�����ĳ��������ݿ���-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt35[0])%>&nbsp;</td>  <!-- ���������-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt41[0])%>&nbsp;</td>  <!-- �������������ݿ���-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt36[0])%>&nbsp;</td>  <!-- �����̰��������-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt39[0])%>&nbsp;</td>  <!-- ������Ʈ�����������-->
            	    <td width="100" align="right"><%=Util.parseDecimal(point_dc_amt[0])%>&nbsp;</td>  <!-- ����Ʈ�����ݾ�(����)-->
            	    <td width="100" align="right">0&nbsp;</td>  <!-- ����Ʈ�����ݾ�(���밪)-->
            	    <td width="100" align="right"><%=Util.parseDecimal(amt46[0])%>&nbsp;</td>  <!-- �縮���������̵�Ź�۷�����ݿ���-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt7[0])%>&nbsp;</td>  <!--��Ÿ-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt8[0])%>&nbsp;</td>  <!--�Ұ� -->
	  	    <td width="80" align="right">
		    <% if (  f_af_amt[0] == 0 ) { %> 0
                    <% } else { %> 
                        <%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[0]/f_af_amt[0]*100),2)%>
                    <% } %>&nbsp;
		    </td>  <!--���뿩���� -->									            
            	    <td width="110" align="right"><%=Util.parseDecimal(amt9[0])%>&nbsp;</td> <!--�⺻���ּҰ������ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt10[0])%>&nbsp;</td> <!--�Ϲݽ��ּҰ������ --> 
            	    <td width="110" align="right"><%=Util.parseDecimal(amt11[0])%>&nbsp;</td> <!--�縮������������ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt12[0])%>&nbsp;</td> <!--�����縮�������� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt13[0])%>&nbsp;</td> <!--����Ŀ�߰�Ź�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt15[0])%>&nbsp;</td> <!--���ú�� -->
           	    	<td width="110" align="right"><%=Util.parseDecimal(amt16[0])%>&nbsp;</td> <!--���޿�ǰ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt17[0])%>&nbsp;</td> <!--�����̹ݿ�����ǰ�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt14[0])%>&nbsp;</td> <!--�����ε�Ź�ۺ��  -->			
            	    <td width="110" align="right"><%=Util.parseDecimal(amt18[0])%>&nbsp;</td> <!--�����ε������� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt33[0])%>&nbsp;</td> <!--��Ʈ����⵿���谡�Ժ�->�ӽÿ��ຸ���-->
            	    <td width="100" align="right"><%=Util.parseDecimal(amt46[0])%>&nbsp;</td>  <!-- �縮���������̵�Ź�۷�����ݿ���-->			
            	    <td width="110" align="right"><%=Util.parseDecimal(amt19[0])%>&nbsp;</td> <!--��Ÿ��� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt37[0])%>&nbsp;</td> <!--��Ÿ��� -->
           	    	<td width="110" align="right"><%=Util.parseDecimal(amt20[0])%>&nbsp;</td> <!--�Ǻ�� -->
           	    	<td width="110" align="right"><%=Util.parseDecimal(amt21[0])%>&nbsp;</td> <!--��ġ -->        
            	    <td width="110" align="right"><%=Util.parseDecimal(amt22[0])%>&nbsp;</td> <!--����D/C -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt23[0])%>&nbsp;</td> <!--�߰�D/C -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt24[0])%>&nbsp;</td> <!--�ܰ�����ũ����ȿ�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt25[0])%>&nbsp;</td> <!--�����������ݸ���  -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt26[0])%>&nbsp;</td> <!--����������ݸ��� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt27[0])%>&nbsp;</td> <!--�°������ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt28[0])%>&nbsp;</td> <!--�����    --> 	
            	    <td width="110" align="right"><%=Util.parseDecimal(amt29[0])%>&nbsp;</td> <!--��Ÿ  -->                   
            	    <td width="110" align="right"><%=Util.parseDecimal(amt30[0])%>&nbsp;</td> <!--�Ұ� -->
                </tr>
                <%	}}%>  
                <%	//��Ÿ-�߰��̿�,�°�,�����
		  		for(int i = 0 ; i < vt_size3 ; i++){
					Hashtable ht = (Hashtable)vts3.elementAt(i);
					
					if(String.valueOf(ht.get("CAR_TYPE")).equals("4")){
					
					rent_way_1_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));
					rent_way_2_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT")));
					rent_way_t_cnt[0] = AddUtil.parseLong(String.valueOf(ht.get("CON_MON")));
					
					af_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AF_AMT")));
					bc_s_g[0] 		= AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")));
					fee_s_amt[0] 		= AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT")));
					f_af_amt[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT")));
					f_fee_s_amt[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("FEE_S_AMT")));
					f_amt8[0] 		= AddUtil.parseFloat(String.valueOf(ht.get("AMT8")));
					
					point_dc_amt[0] 		= 0;
					f_point_dc_amt[0] 		= 0;
					
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
					amt45[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT45")));
					amt46[0] 		= AddUtil.parseLong(String.valueOf(ht.get("AMT46")));
					
					ea_amt[0] 		= amt8[0]-amt21[0]+amt30[0];
					
					af_amt[5] 		+= af_amt[0];
					bc_s_g[5] 		+= bc_s_g[0];
					fee_s_amt[5] 		+= fee_s_amt[0];
					f_af_amt[5] 		+= f_af_amt[0];
					f_fee_s_amt[5] 		+= f_fee_s_amt[0];
					f_amt8[5] 		+= f_amt8[0];
					ea_amt[5] 		+= ea_amt[0];
					
					point_dc_amt[5] 		+= point_dc_amt[0];
					f_point_dc_amt[5] 		+= f_point_dc_amt[0];
					
					amt1[5] 		+= amt1[0];
					amt2[5] 		+= amt2[0];
					amt3[5] 		+= amt3[0];
					amt4[5] 		+= amt4[0];
					amt5[5] 		+= amt5[0];
					amt6[5] 		+= amt6[0];
					amt7[5] 		+= amt7[0];
					amt8[5] 		+= amt8[0];
					amt9[5] 		+= amt9[0];
					amt10[5] 		+= amt10[0];
					amt11[5] 		+= amt11[0];
					amt12[5] 		+= amt12[0];
					amt13[5] 		+= amt13[0];
					amt14[5] 		+= amt14[0];
					amt15[5] 		+= amt15[0];
					amt16[5] 		+= amt16[0];
					amt17[5] 		+= amt17[0];
					amt18[5] 		+= amt18[0];
					amt19[5] 		+= amt19[0];
					amt20[5] 		+= amt20[0];
					amt21[5] 		+= amt21[0];
					amt22[5] 		+= amt22[0];
					amt23[5] 		+= amt23[0];
					amt24[5] 		+= amt24[0];
					amt25[5] 		+= amt25[0];
					amt26[5] 		+= amt26[0];
					amt27[5] 		+= amt27[0];
					amt28[5] 		+= amt28[0];
					amt29[5] 		+= amt29[0];
					amt30[5] 		+= amt30[0];
					amt31[5] 		+= amt31[0];
					amt32[5] 		+= amt32[0];
					amt33[5] 		+= amt33[0];
					amt34[5] 		+= amt34[0];
					amt35[5] 		+= amt35[0];
					amt36[5] 		+= amt36[0];
					amt37[5] 		+= amt37[0];
					amt39[5] 		+= amt39[0];
					amt40[5] 		+= amt40[0];
					amt41[5] 		+= amt41[0];
					amt43[5] 		+= amt43[0];
					amt44[5] 		+= amt44[0];
					amt45[5] 		+= amt45[0];
					amt46[5] 		+= amt46[0];
					
					af_amt[1] 		+= af_amt[0];
					bc_s_g[1] 		+= bc_s_g[0];
					fee_s_amt[1] 		+= fee_s_amt[0];
					f_af_amt[1] 		+= f_af_amt[0];
					f_fee_s_amt[1] 		+= f_fee_s_amt[0];
					f_amt8[1] 		+= f_amt8[0];
					ea_amt[1] 		+= ea_amt[0];
					
					point_dc_amt[1] 		+= point_dc_amt[0];
					f_point_dc_amt[1] 		+= f_point_dc_amt[0];
					
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
					amt45[1] 		+= amt45[0];
					amt46[1] 		+= amt46[0];
					
					//��������		= a_amt+����ȿ��+�縮������������+���޿�ǰ
    					s_tot[0] 		= a_amt[0] +  ea_amt[0] + amt12[0] + amt16[0];
					//Ȱ����		= (����������+��븶��+��Ÿ����)�Ұ�+�⺻���ּҰ������+�Ϲݽ��ּҰ������
    					ac_amt[0]		= amt8[0]+amt9[0]+amt10[0]; 
					//���Ұ�		= ��������+Ȱ����+���ú��
				    	g_tot[0]		= s_tot[0] + ac_amt[0] + amt15[0];
					//��������������
					if (  rent_way_t_cnt[0] == 0 ) {
						ave_amt[0] = 0;
				    	}else{
						ave_amt[0] 	= s_tot[0] / rent_way_t_cnt[0];
					}
                %>
                <tr> 
		    <td width="110" align="right">&nbsp;</td>  <!--���� -->
	  	    <td width="110" align="right"><%=Util.parseDecimal(af_amt[0])%>&nbsp;</td>  <!--���뿩�����簡ġ -->
	  	    <td width="110" align="right"><%=Util.parseDecimal(ea_amt[0])%>&nbsp;</td>  <!--����ȿ�� -->
	  	    <td width="80" align="right">
		    <% if (  af_amt[0] == 0 ) { %> 0
                    <% } else { %> 
                        <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[0]/f_af_amt[0]*100),2)%>
                    <% } %>&nbsp;
		    </td>  <!--���� -->			
	  	    <td width="100" align="right">
		    <% if (  rent_way_1_cnt[0] == 0 ) { %> 0
                    <% } else { %> 
                    <%=Util.parseDecimal(ea_amt[0]/rent_way_1_cnt[0])%>
                    <% } %>&nbsp;
		    </td>  <!--��翵��ȿ�� -->			
	  	    <td width="100" align="right">
		    <% if (  rent_way_t_cnt[0] == 0 ) { %> 0
                    <% } else { %> 
                    <%=Util.parseDecimal(ea_amt[0]/rent_way_t_cnt[0])%>
                    <% } %>&nbsp;
		    </td>  <!--�����翵��ȿ�� -->			
	  	    <td width="110" align="right"><%=Util.parseDecimal(bc_s_g[0])%>&nbsp;</td>  <!--����뿩�� -->
	  	    <td width="110" align="right"><%=Util.parseDecimal(fee_s_amt[0])%>&nbsp;</td>  <!--���뿩�� -->						
	  	    <td width="80" align="right">
		    <% if (  bc_s_g[0] == 0 ) { %> 0
		    <% } else { %> 
		        <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[0]-f_fee_s_amt[0])/(bc_s_g[0]-amt43[0]-amt44[0]) ) * 100),2)%>
		    <% } %>&nbsp;
		    </td>  <!--������ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt1[0])%>&nbsp;</td>  <!--�⺻�İ�����-->
           	    <td width="110" align="right"><%=Util.parseDecimal(amt2[0])%>&nbsp;</td>  <!--�Ϲݽİ�����-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt3[0])%>&nbsp;</td>  <!--��븶��-->
		    <td width="110" align="right"><%=Util.parseDecimal(amt34[0])%>&nbsp;</td>  <!--���Ǻ��谡�Ժ�-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt4[0])%>&nbsp;</td>  <!--�縮���ʱ⿵�����-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt5[0])%>&nbsp;</td>  <!--�縮���߰���������-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt6[0])%>&nbsp;</td>  <!-- ī�����ĳ����-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt40[0])%>&nbsp;</td>  <!-- ī�����ĳ��������ݿ���-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt35[0])%>&nbsp;</td>  <!-- ���������-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt41[0])%>&nbsp;</td>  <!-- �������������ݿ���-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt36[0])%>&nbsp;</td>  <!-- �����̰��������-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt39[0])%>&nbsp;</td>  <!-- ������Ʈ�����������-->
            	    <td width="100" align="right"><%=Util.parseDecimal(point_dc_amt[0])%>&nbsp;</td>  <!-- ����Ʈ�����ݾ�(����)-->
            	    <td width="100" align="right">0&nbsp;</td>  <!-- ����Ʈ�����ݾ�(���밪)-->
            	    <td width="100" align="right"><%=Util.parseDecimal(amt46[0])%>&nbsp;</td>  <!-- �縮���������̵�Ź�۷�����ݿ���-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt7[0])%>&nbsp;</td>  <!--��Ÿ-->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt8[0])%>&nbsp;</td>  <!--�Ұ� -->
	  	    <td width="80" align="right">
		    <% if (  f_af_amt[0] == 0 ) { %> 0
                    <% } else { %> 
                        <%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[0]/f_af_amt[0]*100),2)%>
                    <% } %>&nbsp;
		    </td>  <!--���뿩���� -->									            
            	    <td width="110" align="right"><%=Util.parseDecimal(amt9[0])%>&nbsp;</td> <!--�⺻���ּҰ������ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt10[0])%>&nbsp;</td> <!--�Ϲݽ��ּҰ������ --> 
            	    <td width="110" align="right"><%=Util.parseDecimal(amt11[0])%>&nbsp;</td> <!--�縮������������ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt12[0])%>&nbsp;</td> <!--�����縮�������� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt13[0])%>&nbsp;</td> <!--����Ŀ�߰�Ź�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt15[0])%>&nbsp;</td> <!--���ú�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt16[0])%>&nbsp;</td> <!--���޿�ǰ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt17[0])%>&nbsp;</td> <!--�����̹ݿ�����ǰ�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt14[0])%>&nbsp;</td> <!--�����ε�Ź�ۺ��  -->			
            	    <td width="110" align="right"><%=Util.parseDecimal(amt18[0])%>&nbsp;</td> <!--�����ε������� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt33[0])%>&nbsp;</td> <!--��Ʈ����⵿���谡�Ժ�->�ӽÿ��ຸ���-->		
            	    <td width="100" align="right"><%=Util.parseDecimal(amt46[0])%>&nbsp;</td>  <!-- �縮���������̵�Ź�۷�����ݿ���-->	
            	    <td width="110" align="right"><%=Util.parseDecimal(amt19[0])%>&nbsp;</td> <!--��Ÿ��� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt37[0])%>&nbsp;</td> <!--��Ÿ��� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt20[0])%>&nbsp;</td> <!--�Ǻ�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt21[0])%>&nbsp;</td> <!--��ġ -->        
            	    <td width="110" align="right"><%=Util.parseDecimal(amt22[0])%>&nbsp;</td> <!--����D/C -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt23[0])%>&nbsp;</td> <!--�߰�D/C -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt24[0])%>&nbsp;</td> <!--�ܰ�����ũ����ȿ�� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt25[0])%>&nbsp;</td> <!--�����������ݸ���  -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt26[0])%>&nbsp;</td> <!--����������ݸ��� -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt27[0])%>&nbsp;</td> <!--�°������ -->
            	    <td width="110" align="right"><%=Util.parseDecimal(amt28[0])%>&nbsp;</td> <!--�����    --> 	
            	    <td width="110" align="right"><%=Util.parseDecimal(amt29[0])%>&nbsp;</td> <!--��Ÿ  -->                   
            	    <td width="110" align="right"><%=Util.parseDecimal(amt30[0])%>&nbsp;</td> <!--�Ұ� -->
                </tr>
                <%	}}%>  		  
                <tr> 
		    <td class=title style='text-align:right;'>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(af_amt[5])%>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(ea_amt[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'>
		    <% if (  af_amt[5] == 0 ) { %> 0
                    <% } else { %> 
                        <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[5]/f_af_amt[5]*100),2)%>
                    <% } %>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'>
		    <% if (  rent_way_1_cnt[5] == 0 ) { %> 0
                    <% } else { %> 
                        <%=Util.parseDecimal(ea_amt[5]/rent_way_1_cnt[5])%>
                    <% } %>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'>
		    <% if (  rent_way_t_cnt[5] == 0 ) { %> 0
                    <% } else { %> 
                        <%=Util.parseDecimal(ea_amt[5]/rent_way_t_cnt[5])%>
                    <% } %>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(bc_s_g[5])%>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(fee_s_amt[5])%>&nbsp;</td>		  
            	    <td class=title style='text-align:right;'>
		    <% if (  bc_s_g[5] == 0 ) { %> 0
		    <% } else { %> 
		        <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[5]-f_fee_s_amt[5])/(bc_s_g[5]-amt43[5]-amt44[5]) ) * 100),2)%>
		    <% } %>&nbsp;</td>		  												
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt1[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt2[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt3[5])%>&nbsp;</td>
		    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt34[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt4[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt5[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt6[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt40[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt35[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt41[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt36[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt39[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(point_dc_amt[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'>0&nbsp;</td>
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt46[5])%>&nbsp;</td>  <!-- �縮���������̵�Ź�۷�����ݿ���-->
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt7[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt8[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'>
		    <% if (  af_amt[5] == 0 ) { %> 0
                    <% } else { %> 
			<%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[5]/f_af_amt[5]*100),2)%>
                    <% } %>&nbsp;</td>		  			
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt9[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt10[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt11[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt12[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt13[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt15[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt16[5])%>&nbsp;</td>                       
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt17[5])%>&nbsp;</td>  
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt14[5])%>&nbsp;</td>			
    		    	<td class=title style='text-align:right;'><%= Util.parseDecimal(amt18[5])%>&nbsp;</td> 
    		    	<td class=title style='text-align:right;'><%= Util.parseDecimal(amt33[5])%>&nbsp;</td>
    		    	<td class=title style='text-align:right;'><%=Util.parseDecimal(amt46[5])%>&nbsp;</td>  <!-- �縮���������̵�Ź�۷�����ݿ���--> 			
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt19[5])%>&nbsp;</td> 
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt37[5])%>&nbsp;</td> 
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt20[5])%>&nbsp;</td> 
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt21[5])%>&nbsp;</td>             
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt22[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt23[5])%>&nbsp;</td>  
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt24[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt25[5])%>&nbsp;</td> 
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt26[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt27[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt28[5])%>&nbsp;</td> 
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt29[5])%>&nbsp;</td>
            	    <td class=title style='text-align:right;'><%= Util.parseDecimal(amt30[5])%>&nbsp;</td>          
                </tr>	  		  		    				  
                <tr> 
		    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(af_amt2[1])%>&nbsp;</td>		  
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(af_amt[1])%>&nbsp;</td>		  
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(ea_amt[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'>
		    <% if (  af_amt[1] == 0 ) { %> 0
                    <% } else { %> 
                        <%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[1]/f_af_amt[1]*100),2)%>
                    <% } %>&nbsp;</td>		  
            	    <td class=title_p style='text-align:right;'>
		    <% if (  rent_way_1_cnt[1] == 0 ) { %> 0
                    <% } else { %> 
                        <%=Util.parseDecimal(ea_amt[1]/rent_way_1_cnt[1])%>
                    <% } %>&nbsp;</td>		  
            	    <td class=title_p style='text-align:right;'>
		    <% if (  rent_way_t_cnt[1] == 0 ) { %> 0
                    <% } else { %> 
                        <%=Util.parseDecimal(ea_amt[1]/rent_way_t_cnt[1])%>
                    <% } %>&nbsp;</td>		  
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(bc_s_g[1])%>&nbsp;</td>		  
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(fee_s_amt[1])%>&nbsp;</td>		  
            	    <td class=title_p style='text-align:right;'>
		    <% if (  bc_s_g[1] == 0 ) { %> 0
		    <% } else { %> 
		        <%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[1]-f_fee_s_amt[1])/(bc_s_g[1]-amt43[1]-amt44[1]) ) * 100),2)%>
		    <% } %>&nbsp;</td>		  												
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt1[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt2[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt3[1])%>&nbsp;</td>
		    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt34[1])%>&nbsp;</td>
           	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt4[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt5[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt6[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt40[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt35[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt41[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt36[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt39[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(point_dc_amt[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'>0&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%=Util.parseDecimal(amt46[1])%>&nbsp;</td>  <!-- �縮���������̵�Ź�۷�����ݿ���-->
           	    	<td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt7[1])%>&nbsp;</td>
           	    	<td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt8[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'>
		    <% if (  af_amt[1] == 0 ) { %> 0
                    <% } else { %> 
			<%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[1]/f_af_amt[1]*100),2)%>
                    <% } %>&nbsp;</td>		  			
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt9[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt10[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt11[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt12[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt13[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt15[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt16[1])%>&nbsp;</td>                       
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt17[1])%>&nbsp;</td>  
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt14[1])%>&nbsp;</td>			
    		    	<td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt18[1])%>&nbsp;</td> 
    		    	<td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt33[1])%>&nbsp;</td> 	
    		    	<td class=title_p style='text-align:right;'><%=Util.parseDecimal(amt46[1])%>&nbsp;</td>  <!-- �縮���������̵�Ź�۷�����ݿ���-->		
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt19[1])%>&nbsp;</td> 
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt37[1])%>&nbsp;</td> 
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt20[1])%>&nbsp;</td> 
                    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt21[1])%>&nbsp;</td>             
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt22[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt23[1])%>&nbsp;</td>  
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt24[1])%>&nbsp;</td>
           	    	<td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt25[1])%>&nbsp;</td> 
           	    	<td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt26[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt27[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt28[1])%>&nbsp;</td> 
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt29[1])%>&nbsp;</td>
            	    <td class=title_p style='text-align:right;'><%= Util.parseDecimal(amt30[1])%>&nbsp;</td>          
                </tr>	  				    		  		    				  
            </table>
	</td>
    </tr>
<%	}else{%>                     
    <tr>
	<td class='line' width='400' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>&nbsp;</td>
                </tr>
            </table>
        </td>
	<td class='line' width='5370'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
		    <td>��ϵ� ����Ÿ�� �����ϴ�</td>
		</tr>
	    </table>
	</td>
    </tr>
<% 	}%>
</table>

</form>
</body>
</html>
